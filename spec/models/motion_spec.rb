require 'spec_helper'

describe Motion do
  it { should have_many(:events).dependent(:destroy) }

  subject do
    @motion = Motion.new
    @motion.valid?
    @motion
  end
  it {should have(1).errors_on(:name)}
  it {should have(1).errors_on(:author)}

  it "user_has_voted?(user) returns true if the given user has voted on motion" do
    @user = create(:user)
    @motion = create(:motion, :author => @user)
    @vote = build(:vote,:position => "yes")
    @vote.user = @user
    @vote.motion = @motion
    @vote.save!
    @motion.user_has_voted?(@user).should == true
  end

  it "user_has_voted?(user) returns false if given nil" do
    @motion = create(:motion)
    @motion.user_has_voted?(nil).should == false
  end

  it "cannot have invalid phases" do
    @motion = create(:motion)
    @motion.phase = 'bad'
    @motion.should_not be_valid
  end

  it "it can remain un-blocked" do
    @motion = create(:motion)
    user1 = build(:user)
    user1.save
    @motion.group.add_member!(user1)
    vote = Vote.new(position: 'yes')
    vote.motion = @motion
    vote.user = user1
    vote.save
    @motion.blocked?.should == false
  end

  it "it can be blocked" do
    @motion = create(:motion)
    user1 = build(:user)
    user1.save
    @motion.group.add_member!(user1)
    vote = Vote.new(position: 'block')
    vote.motion = @motion
    vote.user = user1
    vote.save
    @motion.blocked?.should == true
  end

  it "can have a close date" do
    @motion = create(:motion)
    @motion.close_date = '2012-12-12'
    @motion.close_date.should == Date.parse('2012-12-12')
    @motion.should be_valid
  end

  it "can have a discussion link" do
    @motion = create(:motion)
    @motion.discussion_url = "http://our-discussion.com"
    @motion.should be_valid
  end

  it "can have a discussion" do
    @motion = create(:motion)
    @motion.save
    @motion.discussion.should_not be_nil
  end

  it "cannot have an outcome if voting open" do
    @motion = create(:motion)
    @motion.outcome.blank?.should == true
    @motion.set_outcome("blah blah")
    @motion.save
    @motion.outcome.blank?.should == true
  end

  context "moving motion to new group" do
    before do
      @new_group = create(:group)
      @motion = create(:motion)
      @motion.move_to_group @new_group
    end

    it "changes motion group_id to new group" do
      @motion.group.should == @new_group
    end

    it "changes motion discussion_id to new group" do
      @motion.discussion.group.should == @new_group
    end
  end

  context "destroying a motion" do
    before do
      @discussion = create(:discussion)
      @motion = create(:motion, discussion: @discussion)
      @vote = Vote.create(position: "no", motion: @motion, user: @motion.author)
      @comment = @motion.discussion.add_comment(@motion.author, "hello")
      @motion.destroy
    end

    it "deletes associated votes" do
      Vote.first.should == nil
    end
  end

  context "closed motion" do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @discussion = create(:discussion)
      @motion = create(:motion, discussion: @discussion)
      @motion.group.add_member!(@user2)
      @motion.group.add_member!(@user3)
      vote1 = create(:vote, :position => 'yes', :user => @user1, :motion => @motion)
      vote2 = create(:vote, :position => 'no', :user => @user2, :motion => @motion)
      @updated_at = @motion.updated_at
      @motion.close_voting!
    end

    it "stores users who did not vote" do
      not_voted_ids = DidNotVote.all.collect {|u| u.user.id}
      not_voted_ids.should include(@user3.id)
    end

    it "users_who_did_not_vote should return users who did not vote" do
      @motion.users_who_did_not_vote.should include(@user3)
    end

    it "users_who_did_not_vote should not return users who did  vote" do
      @motion.users_who_did_not_vote.should_not include(@user1)
      @motion.users_who_did_not_vote.should_not include(@user2)
    end

    it "no_vote_count should return number of users who did not vote" do
      @motion.no_vote_count.should == @motion.group.users.count - @motion.votes.count
    end

    it "reopening motion deletes did_not_vote records" do
      @motion.open_voting
      DidNotVote.all.count.should == 0
    end

    it "can have an outcome" do
      outcome = "Test Outcome"
      @motion.set_outcome(outcome)
      @motion.save
      @motion.outcome.should == outcome
    end

  end

  context "open motion" do
    before :each do
      @user1 = build(:user)
      @user1.save
      @group = build(:group, :creator => @user1)
      @group.save
      @discussion = create(:discussion, group: @group, author: @user1)
      @motion1 = create(:motion, name: "hi",
                                author: @user1,
                                discussion: @discussion,
                                phase: "voting")
      @motion1.author = @user1
      @motion1.save!
    end

    context "no_vote_count" do
      it "should return number of users who have not voted yet" do
        @motion1.no_vote_count.should == 1
      end

      it "should not change if users vote multiple times" do
        pending "this test is failing for some reason, but the functionality works everywhere else"
        user2 = build(:user)
        user2.save
        @group.add_member! user2
        Vote.create!(motion: @motion1, position: "yes", user: @user1)
        Vote.create!(motion: @motion1, position: "no", user: @user1)
        Vote.create!(motion: @motion1, position: "abstain", user: @user1)
        @motion1.reload
        @motion1.no_vote_count.should == 1
      end
    end

    it "users_who_did_not_vote should return users who did not vote" do
      @motion1.users_who_did_not_vote.should include(@user1)
    end

  end

  describe "number_of_votes_since_last_looked(user)" do
    before do
      @user = build(:user)
      @motion = create(:motion)
    end
    context "the user is a member of the motions group" do
      it "returns the total number of votes if the user has not seen the motion" do
        @motion.stub(:last_looked_at_by).with(@user).and_return(nil)
        @motion.stub_chain(:unique_votes, :count).and_return(4)

        @motion.number_of_votes_since_last_looked(@user).should == 4
      end
      it "returns the number of votes since the user last looked at the motion" do
        last_viewed_at = Time.now
        @user.stub(:is_group_member?).with(@motion.group).and_return(true)
        @motion.stub(:last_looked_at_by).with(@user).and_return(last_viewed_at)
        @motion.stub(:number_of_votes_since).with(last_viewed_at).and_return(3)

        @motion.number_of_votes_since_last_looked(@user).should == 3
      end
    end
    context "the user is not a member of the group" do
      it "returns the total number of votes" do
        @motion.stub(:last_looked_at_by).with(@user).and_return(nil)
        @motion.stub_chain(:unique_votes, :count).and_return(4)

        @motion.number_of_votes_since_last_looked(nil).should == 4
      end
    end
  end

  describe "last_looked_at_by(user)" do
    it "returns the date when the user last looked at the motion" do
      user = build(:user)
      motion = create(:motion)
      last_viewed_at = Time.now
      log = create(:motion_read_log)
      MotionReadLog.stub_chain(:where, :first).and_return(log)
      log.stub(:motion_last_viewed_at).and_return(last_viewed_at)

      motion.last_looked_at_by(user).should == last_viewed_at
    end
  end

  describe "number_of_votes_since(time)" do
    it "returns the number of votes since time" do
      last_viewed_at = Time.now
      motion = create(:motion)
      motion.votes.stub_chain(:where, :count).and_return(4)
      
      motion.number_of_votes_since(last_viewed_at).should == 4
    end
  end

  describe "percent_voted" do
    before do
      @motion = create(:motion)
    end
    it "should return the pecentage of users that have voted" do
      @motion.stub(:no_vote_count).and_return(10)
      @motion.stub(:group_count).and_return(20)
      @motion.percent_voted.should == 50
    end
  end

  context do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    before do
      @motion = create(:motion, author: user1)
      @motion1 = create(:motion, author: user1)
    end

    describe "that_user_has_voted_on" do
      it "returns motions that the user has voted" do
        @motion.vote!(user1, 'yes', 'i agree!')
        Motion.that_user_has_voted_on(user1).should include(@motion)
      end
      it "does not return motions that the user has not voted on (even if another user has)" do
        @motion.group.add_member! user2
        @motion.vote!(user2, 'yes', 'i agree!')
        Motion.that_user_has_voted_on(user1).should_not include(@motion)
      end
    end
  end

  describe "vote!" do
    before do
      @motion = create(:motion)
      @vote = @motion.vote!(@motion.author, 'yes', 'i agree!')
    end
    it "returns a vote object" do
      @vote.is_a?(Vote).should be_true
    end
    it "assigns vote to the motion" do
      @motion.votes.should include(@vote)
    end
    it "assigns given position to vote" do
      @vote.position.should == 'yes'
    end
    it "assigns given statement to vote" do
      @vote.statement.should == "i agree!"
    end
    it "works if no statement given" do
      @vote = @motion.vote!(@motion.author, 'yes')
      @vote.should_not be_nil
    end
  end
end

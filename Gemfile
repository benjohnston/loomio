source 'http://rubygems.org'

ruby '2.2.2'
gem 'mime-types', '~> 2.6.1', require: 'mime/types/columnar'
gem 'rails', '~> 4.2.3'
gem 'rake'
gem 'pg', '~> 0.18.2'
gem 'pg_search', '~> 1.0.4'
gem 'haml-rails', '~> 0.9.0'
gem 'devise', '~> 3.4.1'
gem 'devise-i18n'
gem 'omniauth', '~> 1.2.2'
gem 'omniauth-google-oauth2', '~> 0.2.5'
gem 'omniauth-facebook', '~> 2.0.1'
gem 'omniauth-twitter', '~> 1.2.0'
gem 'active_model_serializers', '~> 0.8.1'
gem 'private_pub', github: 'loomio/private_pub'
gem 'omniauth-browserid'
gem 'omnicontacts', github: 'Diego81/omnicontacts', ref: 'beca38666154d660c472e5efba2197f164acd1ff'
gem 'jquery-rails', '~> 4.0.3'
gem 'jquery-ui-rails', '~> 5.0.0'
gem 'simple_form', '3.1.0'
gem 'cancancan'
gem 'gravtastic'
gem 'paperclip', '~> 4.2.4'
gem 'kaminari'
gem 'activeadmin', github: 'activeadmin'
gem 'nokogiri'
gem 'twitter-text'
gem 'jquery-atwho-rails', '~> 0.4.11'
gem 'redcarpet', '~> 3.2.3'
gem 'paper_trail', '~> 4.0.0.beta2'
gem 'delayed_job', '~> 4.0.2'
gem 'delayed_job_active_record', '~> 4.0.1'
gem 'foreman'
gem 'rinku'
gem 'friendly_id', '~> 5.1.0'
gem 'httparty'
gem 'airbrake'
gem 'browser'
gem 'fog'
gem 'thin'
gem 'roadie-rails', '~> 1.0.2'
gem 'sequenced', '~> 2.0.0'
gem 'closure_tree', '~> 5.2.0'
gem 'bing_translator'
gem 'http_accept_language'
gem 'intercom'
gem 'intercom-rails'
gem 'underscore-rails'
gem "font-awesome-sass",  '~> 4.3.2'
gem 'coffee-rails'
gem 'sprockets-rails', require: 'sprockets/railtie'
gem 'uglifier'
gem 'bootstrap-sass', '~> 3.3.4'
gem 'sass-rails', '>= 3.2'
gem 'autoprefixer-rails'
gem 'modernizr-rails'
gem 'jquery-fileupload-rails'
gem 'momentjs-rails'
gem 'ruby-progressbar'
gem 'responders', '~> 2.0'
gem 'activerecord_any_of'
gem 'rack-attack', '~> 4.2.0'
gem 'ahoy_matey'
gem 'oj'
gem 'oj_mimic_json'
# might need this
#gem 'activeuuid', '>= 0.5.0'

gem 'snorlax', '~> 0.1.3'
gem 'custom_counter_cache'

# consider uncommenting these when we want to mess around with json parsing
#gem 'oj'
#gem 'oj_mimic_json'

group :development, :test do
  gem 'minitest'
  gem 'timecop'
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec-collection_matchers'
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'dotenv-rails', :require => 'dotenv/rails-now'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end

group :development do
  gem 'derailed'
  gem "stackprof"
  gem 'spring'
  gem "spring-commands-cucumber"
  gem "spring-commands-rspec"
  #gem 'bullet'
  gem 'launchy'
  gem 'awesome_print'
  #gem 'quiet_assets'
  #gem 'meta_request'
  #gem 'better_errors'
  #gem 'binding_of_caller'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'email_spec'
  gem 'poltergeist'
  gem 'webmock'
  gem "codeclimate-test-reporter", require: false
  gem 'rack_session_access'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'rails_serve_static_assets'
  gem 'delayed-plugins-airbrake'
  gem 'dalli'
  gem 'newrelic_rpm'
  gem 'heroku-deflater'
end

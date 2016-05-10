module ConfigHelper

  def set_app_config
    @appConfig ||= {
      version:             Loomio::Version.current,
      showWelcomeModal:    !current_user_or_visitor.angular_ui_enabled?,
      reportErrors:        false,
      environment:         Rails.env,
      loadVideos:          (ENV.has_key?('LOOMIO_LOAD_VIDEOS') or Rails.env.production?),
      flash:               flash.to_h,
      currentUserId:       current_user_or_visitor.id,
      currentUserLocale:   current_user_or_visitor.locale,
      currentUserData:    (current_user_serializer.new(current_user_or_visitor, root: 'current_user').as_json),
      currentUrl:          request.original_url,
      canTranslate:        TranslationService.available?,
      permittedParams:     PermittedParamsSerializer.new({}),
      locales:             angular_locales,
      siteName:            ENV['SITE_NAME'] || 'Loomio',
      twitterHandle:       ENV['TWITTER_HANDLE'] || '@loomio',
      baseUrl:             root_url,
      safeThreadItemKinds: Discussion::THREAD_ITEM_KINDS,
      plugins:             Plugins::Repository.to_config,
      chargify:            app_config_chargify,
      mobileHost:         (ENV['MOBILE_HOST'] if is_mobile_app_request?),
      pageSize: {
        default:           ENV['DEFAULT_PAGE_SIZE'] || 30,
        groupThreads:      ENV['GROUP_PAGE_SIZE'],
        threadItems:       ENV['THREAD_PAGE_SIZE'],
        exploreGroups:     ENV['EXPLORE_PAGE_SIZE'] || 10
      }
    }
  end

  private

  def app_config_chargify
    return unless Rails.application.secrets.chargify_app_name
    {
      appName: Rails.application.secrets.chargify_app_name,
      host: "https://#{Rails.application.secrets.chargify_app_name}.chargify.com/",
      plans: {
        standard: {
          name: Rails.application.secrets.chargify_standard_plan_name,
          path: "subscribe/#{Rails.application.secrets.chargify_standard_plan_key}/#{Rails.application.secrets.chargify_standard_plan_name}",
        },
        plus: {
          name: Rails.application.secrets.chargify_plus_plan_name,
          path: "subscribe/#{Rails.application.secrets.chargify_plus_plan_key}/#{Rails.application.secrets.chargify_plus_plan_name}"
        }
      },
      donation_url: Rails.application.secrets.chargify_donation_url,
    }
  end

  def app_config_intercom
    return unless Rails.application.secrets.intercom_app_id && current_user_or_visitor.is_logged_in?
    {
      appId:    Rails.application.secrets.intercom_app_id,
      secret:   Rails.application.secrets.intercom_app_secret,
      userHash: Digest::SHA1.hexdigest(Rails.application.secrets.intercom_app_secret+current_user.id.to_s)
    }
  end
end
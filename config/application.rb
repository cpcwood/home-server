require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HomeServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.middleware.use Rack::Attack

    config.generators do |g|
      g.test_framework  :rspec, :fixture => false
      g.template_engine :erb
      g.view_specs      false
      g.helper_specs    false
      g.stylesheets     false
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_storage.queues.purge = :default
    config.active_storage.queues.analysis = :default

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      html_tag
    }

    config.autoload_paths += Dir[Rails.root.join('app', 'jobs', '**/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '**/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'mailers', '**/')]

    # email
    config.email_default_name = ENV['EMAIL_DEFAULT_NAME']
    config.email_default_address = ENV['EMAIL_DEFAULT_ADDRESS']
    config.email_no_reply_address = ENV['EMAIL_NO_REPLY_ADDRESS']

    # google recaptcha
    config.grecaptcha_site_secret = ENV['GRECAPTCHA_SITE_SECRET']

    # active record encryption
    config.active_record.encryption.primary_key = ENV['AR_ENCRYPTION_PRIMARY_KEY']
    config.active_record.encryption.deterministic_key = ENV['AR_ENCRYPTION_DETERMINISTIC_KEY']
    config.active_record.encryption.key_derivation_salt = ENV['AR_ENCRYPTION_KEY_DERIVATION_SALT']

    # Image processing
    config.active_storage.variant_processor = :mini_magick

    # Active storage
    config.active_storage.service_urls_expire_in = 1.week
  end
end

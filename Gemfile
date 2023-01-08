source 'https://rubygems.org'

ruby '3.2.0'

# Rails
gem 'rails', '~> 7.0'
# Ensure assets pipeline from v6 still works
gem 'sprockets-rails', "~> 3.4"
# Turbo rails
gem 'turbo-rails', "~> 1.1"
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1'
# Throttle excessive requests
gem 'rack-attack', '~> 6.6'
# Send HTTP Requests
gem 'faraday', "~> 2.5", require: false
# Verify 2FA using twilio
gem 'twilio-ruby', '~> 5.72', require: false
# Action Mailer and Action Job Backend - Sidekiq (Requires redis and start upon server launch)
gem 'sidekiq', '~> 6.5'
# Transform uploaded images
gem 'image_processing', "~> 1.12"
# Process markdown
gem 'redcarpet', "~> 3.5"
# Markdown syntax highlighing
gem 'rouge', "~> 4.0"
# Validate urls in model
gem 'validate_url', "~> 1.0"
# Validate dates in model
gem 'date_validator', "~> 0.12"
# Timezone
gem 'tzinfo-data', "~> 1.2022"
# JSON API serializer
gem 'jsonapi-serializer', "~> 2.2"
# mime types
gem 'mimemagic', "~> 0.4"
# Tasks
gem 'rake', "~> 13.0"
# Pageviews
gem 'ahoy_matey', "~> 4.1"
gem 'geocoder', "~> 1.8"
gem 'maxminddb', "~> 0.1"

group :production do
  # AWS S3 for production storage
  gem 'aws-sdk-s3', "~> 1.114", require: false
  # Ensure sidekiq stays alive in k8s
  gem 'sidekiq_alive', "~> 2.1"
  # Dynamically generate sitemaps
  gem 'sitemap_generator', "~> 6.3"
  # Manage cron
  gem 'whenever', "~> 1.0", require: false
  # Error Reporting
  gem 'sentry-ruby', "~> 5.4"
  gem 'sentry-rails', "~> 5.4"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', "~> 11.1", platforms: [:mri, :mingw, :x64_mingw]
  # Code policing with rubocop
  gem 'rubocop-rails', '~> 2.16', require: false
  gem 'rubocop-performance', '~> 1.15', require: false
  # Some real nice printing
  gem 'amazing_print', "~> 1.4"
  # Manage models in spec
  gem 'factory_bot_rails', "~> 6.2"
  # Listen - required for rails dev environment
  gem 'listen', '~> 3.0', '< 3.2'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '~> 4.2'
  # Annotate models for quick reference
  gem 'annotate', "~> 3.2"
  # Static security testing
  gem 'brakeman', "~> 5.3"
  # Lint erb
  gem 'erb_lint', '~> 0.0'
end

group :test do
  # Testing backend with RSpec
  gem 'rspec-rails', '~> 5.1', require: false
  gem 'rails-controller-testing', "~> 1.0"
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.37', require: false
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', "~> 5.0", require: false
  # Coverage with simplecov
  gem 'simplecov', "~> 0.16", require: false
  gem 'simplecov-console', "~> 0.9", require: false
  # Coverage badge with coveralls
  gem 'coveralls', '~> 0.8', require: false
  # Mock HTTP Requests
  gem 'webmock', "~> 3.18", require: false
  # Clean up the messy database during tests
  gem 'database_cleaner-active_record', '~> 2.0', require: false
  # Format tests for circleci
  gem 'rspec_junit_formatter', "~> 0.5"
  # Load spec env
  gem 'dotenv', "~> 2.8"
  # Screenshot failed feature specs
  gem 'capybara-screenshot', "~> 1.0"
end



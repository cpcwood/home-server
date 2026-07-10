source 'https://rubygems.org'

ruby '3.4.9'

# Rails
gem 'rails', '~> 8.1'
# Ensure assets pipeline from v6 still works
gem 'sprockets-rails', '~> 3.5'
# Turbo rails
gem 'turbo-rails', '~> 2.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 8'
# Transpile app-like JavaScript. Read more: https://github.com/shakacode/shakapacker
gem 'shakapacker', '~> 10.3'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1'
# Throttle excessive requests
gem 'rack-attack', '~> 6.8'
# Send HTTP Requests
gem 'faraday', '~> 2.14', require: false
# Verify 2FA using twilio
gem 'twilio-ruby', '~> 7.10', require: false
# Action Mailer and Action Job Backend - Sidekiq (Requires redis and start upon server launch)
gem 'sidekiq', '~> 8.1'
# Transform uploaded images
gem 'image_processing', '~> 2.0'
# ImageMagick wrapper for variant processing + EXIF (image_processing 2 no longer depends on it).
# Held at 4.x: mini_magick 5 removed Image#mime_type and Image#exif, which Image/GalleryImage rely on.
gem 'mini_magick', '~> 4.13'
# Process markdown
gem 'redcarpet', '~> 3.6'
# Markdown syntax highlighing
gem 'rouge', '~> 5.0'
# Validate urls in model
gem 'validate_url', '~> 1.0'
# Validate dates in model
gem 'date_validator', '~> 0.12'
# Timezone
gem 'tzinfo-data', '~> 1.2026'
# JSON API serializer
gem 'jsonapi-serializer', '~> 2.2'
# mime types
gem 'mimemagic', '~> 0.4'
# Tasks
gem 'rake', '~> 13.4'
# Pageviews
gem 'ahoy_matey', '~> 5.5'
gem 'geocoder', '~> 1.8'
gem 'maxminddb', '~> 0.1'

group :production do
  # AWS S3 for production storage
  gem 'aws-sdk-s3', '~> 1.227', require: false
  # Ensure sidekiq stays alive in k8s
  gem 'sidekiq_alive', '~> 2.5'
  # Dynamically generate sitemaps
  gem 'sitemap_generator', '~> 7.1'
  # Manage cron
  gem 'whenever', '~> 1.1', require: false
  # Error Reporting
  gem 'sentry-ruby', '~> 6.6'
  gem 'sentry-rails', '~> 6.6'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 13.0', platforms: [:mri, :mingw, :x64_mingw]
  # Code policing with rubocop
  gem 'rubocop-rails', '~> 2.35', require: false
  gem 'rubocop-performance', '~> 1.26', require: false
  # Some real nice printing
  gem 'amazing_print', '~> 2.0'
  # Manage models in spec
  gem 'factory_bot_rails', '~> 6.5'
  # Listen - required for rails dev environment
  gem 'listen', '~> 3.9'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '~> 4.3'
  # Annotate models for quick reference (maintained fork of the abandoned annotate gem)
  gem 'annotaterb', '~> 4.23'
  # Static security testing
  gem 'brakeman', '~> 8.0'
  # Lint erb
  gem 'erb_lint', '~> 0.9'
end

group :test do
  # Testing backend with RSpec
  gem 'rspec-rails', '~> 8.0', require: false
  gem 'rails-controller-testing', '~> 1.0'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.40', require: false
  # Selenium 4 bundles selenium-manager for driver resolution (replaces webdrivers)
  gem 'selenium-webdriver', '~> 4.45', require: false
  # Coverage with simplecov
  gem 'simplecov', '~> 0.22', require: false
  gem 'simplecov-console', '~> 0.9', require: false
  # Coverage badge with coveralls (maintained fork of the abandoned coveralls gem)
  gem 'coveralls_reborn', '~> 0.29', require: false
  # Mock HTTP Requests
  gem 'webmock', '~> 3.26', require: false
  # Clean up the messy database during tests
  gem 'database_cleaner-active_record', '~> 2.2', require: false
  # Format tests for circleci
  gem 'rspec_junit_formatter', '~> 0.6'
  # Load spec env
  gem 'dotenv', '~> 3.2'
  # Screenshot failed feature specs
  gem 'capybara-screenshot', '~> 1.0'
end

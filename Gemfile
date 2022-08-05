source 'https://rubygems.org'

ruby '3.1.2'

# Bundler for running commands in containers
gem 'bundler', '~> 2.3.18'

# Rails
gem 'rails', '~> 7.0'
# Ensure assets pipeline from v6 still works
gem 'sprockets-rails'
# Turbo rails
gem 'turbo-rails'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3'
# Throttle excessive requests
gem 'rack-attack', '~> 6'
# Send HTTP Requests
gem 'faraday', require: false
# Verify 2FA using twilio
gem 'twilio-ruby', '~> 5', require: false
# Action Mailer and Action Job Backend - Sidekiq (Requires redis and start upon server launch)
gem 'sidekiq', '~> 6'
# Transform uploaded images
gem 'image_processing'
# Process markdown
gem 'redcarpet'
# Markdown syntax highlighing
gem 'rouge'
# Validate urls in model
gem 'validate_url'
# Validate dates in model
gem 'date_validator'
# Timezone
gem 'tzinfo-data'
# JSON API serializer
gem 'jsonapi-serializer'
# mime types
gem 'mimemagic'
# Tasks
gem 'rake'

group :production do
  # AWS S3 for production storage
  gem 'aws-sdk-s3', require: false
  # Ensure sidekiq stays alive in k8s
  gem 'sidekiq_alive'
  # Dynamically generate sitemaps
  gem 'sitemap_generator'
  # Manage cron
  gem 'whenever', require: false
  # Error Reporting
  gem 'sentry-ruby'
  gem 'sentry-rails'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Code policing with rubocop
  gem 'rubocop-rails', '~> 2', require: false
  gem 'rubocop-performance', '~> 1', require: false
  # Some real nice printing
  gem 'amazing_print'
  # Manage models in spec
  gem 'factory_bot_rails'
  # Listen - required for rails dev environment
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Annotate models for quick reference
  gem 'annotate'
  # Static security testing
  gem 'brakeman'
  # Lint erb
  gem 'erb_lint', '~> 0.0.35'
end

group :test do
  # Testing backend with RSpec
  gem 'rspec-rails', '~> 5', require: false
  gem 'rails-controller-testing'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3', require: false
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', require: false
  # Coverage with simplecov
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
  # Coverage badge with coveralls
  gem 'coveralls', '~> 0.8.23', require: false
  # Mock HTTP Requests
  gem 'webmock', require: false
  # Clean up the messy database during tests
  gem 'database_cleaner-active_record', '>= 1.8.0', require: false
  # Format tests for circleci
  gem 'rspec_junit_formatter'
  # Load spec env
  gem 'dotenv'
  # Screenshot failed feature specs
  gem 'capybara-screenshot'
end



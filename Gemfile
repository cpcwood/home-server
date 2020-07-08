source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Dynamic creation of JSONs
gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Throttle excessive requests
gem 'rack-attack', '~> 6.3.0'
# Send HTTP Requests
gem 'faraday', require: false
# Verify 2FA using twilio
gem 'twilio-ruby', '~> 5.34', require: false
# Action Mailer and Action Job Backend - Sidekiq (Requires redis and start upon server launch)
gem 'sidekiq', '~> 6.0.7'
# Transform uploaded images
gem 'image_processing'

group :production do
  # AWS S3 for production storage
  gem 'aws-sdk-s3', require: 'false'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Code policing with rubocop
  gem 'rubocop-rails', '~> 2.5.2', require: false
  gem 'rubocop-performance', '~> 1.5.2', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Testing backend with RSpec
  gem 'rspec-rails', '~> 4.0', require: false
  gem 'rails-controller-testing'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', require: false
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '~> 4.3', require: false
  # Coverage with simplecov
  gem 'simplecov', '~> 0.16.1', require: false
  gem 'simplecov-console', '~> 0.7.2', require: false
  # Coverage badge with coveralls
  gem 'coveralls', '~> 0.8.23', require: false
  # Mock HTTP Requests
  gem 'webmock', '~> 3.8.3', require: false
  # Clean up the messy database during tests
  gem 'database_cleaner-active_record', '>= 1.8.0', require: false
end

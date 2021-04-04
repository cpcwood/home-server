ENV['RAILS_ENV'] = 'test'

require 'dotenv'
Dotenv.load('config/env/test-defaults.env')

`
if bundle exec rake db:exists; then
    bundle exec rake db:migrate
else
    bundle exec rake db:setup
fi
`

require 'coveralls'
Coveralls.wear!('rails')

require 'simplecov'
require 'simplecov-console'
require 'rails_helper'
require 'capybara'
require 'webdrivers'
require 'sidekiq/testing'
require 'database_cleaner/active_record'

Selenium::WebDriver::Chrome::Service.driver_path = ENV['CHROMEDRIVER'] if ENV['CHROMEDRIVER']

Capybara.register_driver :headless_chrome_driver do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new(args: ['--headless', '--no-sandbox'])
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.server = :puma, { Silent: true }
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :headless_chrome_driver

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::Console, Coveralls::SimpleCov::Formatter])
SimpleCov.start 'rails' do
  add_filter 'app/channels'
  add_filter '/spec/'
end

require 'webmock/rspec'

whitelist = ['chromedriver.storage.googleapis.com', 'github.com', 'amazonaws.com']
allowed_sites = ->(uri){ uri.host.match?(Regexp.union(whitelist)) }
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: allowed_sites)

# require helper methods
Dir[Rails.root.join('spec/spec_helpers/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    `bin/webpack`
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test
    DatabaseCleaner.strategy = :truncation unless driver_shares_db_connection_with_specs
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on a real object.
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation

  config.after(:suite) do
    puts
  end
end

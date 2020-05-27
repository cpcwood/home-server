require 'coveralls'
Coveralls.wear!('rails')

require 'simplecov'
require 'simplecov-console'
require 'rails_helper'
require 'webdrivers'
require 'sidekiq/testing'

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome_headless

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::Console, Coveralls::SimpleCov::Formatter])
SimpleCov.start 'rails' do
  add_filter 'app/channels'
  add_filter 'app/helpers'
end

require 'webmock/rspec'

whitelist = ['chromedriver.storage.googleapis.com', 'github.com', 'amazonaws.com']
allowed_sites = ->(uri){ uri.host.match?(Regexp.union(whitelist)) }
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: allowed_sites
)

RSpec.configure do |config|
  config.before(:suite) do
    `bin/webpack`
  end

  config.before(:each) do
    @test_user = User.create(username: 'admin', email: 'admin@example.com', password: 'Securepass1', mobile_number: '+15005550006')
  end

  config.after(:each) do
    User.destroy_all
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

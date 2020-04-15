require 'coveralls'
Coveralls.wear!('rails')

require 'simplecov'
require 'simplecov-console'
require 'rails_helper'
require 'webdrivers'

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome_headless

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::Console])
SimpleCov.start 'rails' do
  add_filter 'bin/'
  add_filter 'db/'
  add_filter 'spec/'
  add_filter 'app/models/application_record.rb'
  add_filter 'app/channels/application_cable/connection.rb'
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/channels/application_cable/channel.rb'
  add_filter 'app/helpers/application_helper.rb'
  add_filter 'app/helpers/homepage_helper.rb'
  add_filter 'app/jobs/application_job.rb'
end

RSpec.configure do |config|
  config.before(:suite) do
    `bin/webpack`
  end

  config.before(:all) do
  end

  config.after(:all) do
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

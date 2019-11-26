ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'spec_helper'
require 'rspec/rails'
require "email_store"
require 'factory_bot_rails'
require 'database_cleaner'

ActiveRecord::Migrator.migrations_paths = [File.expand_path("../spec/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __dir__)
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, { pre_count: true, reset_ids: false })
  end

  # Use transactions for non-javascript tests as it is much faster than truncation
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    DatabaseCleaner.clean_with(:truncation, { pre_count: true, reset_ids: false })
  end
end

Capybara.register_driver :ie_7_driver do |app|
  Capybara::RackTest::Driver.new(app, :headers => { 'HTTP_USER_AGENT' => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)' })
end

require 'webdrivers'

Webdrivers.install_dir = Rails.root.join('vendor', 'webdrivers')
Webdrivers.cache_time = 86_400

Capybara.register_driver :headless_chrome do |app|
  if ENV['SELENIUM_HOST']
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub",
      desired_capabilities: :chrome
    )
  else
    chrome_options = Selenium::WebDriver::Chrome::Options.new
    chrome_options.add_argument('--headless') unless ENV['SHOW_CHROME']
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-infobars')
    chrome_options.add_argument('--disable-extensions')
    chrome_options.add_argument('--disable-popup-blocking')
    chrome_options.add_argument('--window-size=1920,1080')
    
    Capybara::Selenium::Driver.new app, browser: :chrome, options: chrome_options
  end
end
Capybara.javascript_driver = :headless_chrome


require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

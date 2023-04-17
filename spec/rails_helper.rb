ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "capybara/rails"
require "capybara/rspec"
require "webdrivers/chromedriver"

Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Capybara.default_driver = :selenium_chrome if ENV["chrome"].present?
WebMock.disable_net_connect!(allow_localhost: true, allow: "chromedriver.storage.googleapis.com")

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.order = :random
  config.include FactoryBot::Syntax::Methods
  config.include SessionHelper, type: :feature
  config.filter_rails_from_backtrace!

  config.before(:each, type: :system, javascript: true) do
    driven_by :selenium_chrome_headless
  end
end

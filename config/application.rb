require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HrTil
  class Application < Rails::Application
    config.load_defaults 7.0
    config.active_record.schema_format = :sql
    config.time_zone = "Eastern Time (US & Canada)"
    config.autoload_paths << Rails.root.join("lib")
    # Initialize configuration defaults for originally generated Rails version.

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

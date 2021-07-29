require_relative "boot"

require "rails/all"
require "connection_pool"
require "pg"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.connection_pool = ConnectionPool.new(size: 5, timeout: 5) do 
      PG.connect(
        dbname: ENV['POSTGRES_DB'],
        user: ENV['POSTGRES_USER'],
        password: ENV['POSTGRES_PASSWORD'],
        host: ENV['POSTGRES_HOST'],
      )
    end
  end
end

require 'dry/effects'

module AccSysMiddlewares
  class ConnectionMiddleware
    include Dry::Effects::Handler.Reader(:connection)

    def initialize(app)
      @app = app
    end

    def call(env)
      Rails.configuration.connection_pool.with do |conn|
        with_connection(conn) do
          @app.(env)
        end
      end
    end
  end
end

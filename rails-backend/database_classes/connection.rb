require 'pg'


module Database
  class Connection
    def get_connection
      @connection = PG.connect(
        dbname: ENV['POSTGRES_DB'],
        user: ENV['POSTGRES_USER'],
        password: ENV['POSTGRES_PASSWORD'],
        host: ENV['POSTGRES_HOST'],
      )
      @connection
    end

    def get_test_connection
      @test_connection = PG.connect(
        dbname: ENV['POSTGRES_DB_TEST'],
        user: ENV['POSTGRES_USER'],
        password: ENV['POSTGRES_PASSWORD'],
        host: ENV['POSTGRES_HOST'],
      )
      @test_connection
    end
  end

  class ConnectionPool
    def get_connection_from_pool
      Rails.configuration.connection_pool.with do |conn|
        conn
      end
    end
  end
end

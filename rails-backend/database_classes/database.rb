require 'pg'


module Database
  class Database
    def initialize(name)
      @name = name.downcase
      @connection = PG.connect(
        dbname: ENV['POSTGRES_DB'],
        user: ENV['POSTGRES_USER'],
        password: ENV['POSTGRES_PASSWORD'],
        host: ENV['POSTGRES_HOST'],
      )
    end

    def create
      query = "CREATE DATABASE $1;"
      params = [@name]
      @connection.exec_params(query, params)
    end

    def drop
      query = "DROP DATABASE $1;"
      params = [@name]
      @connection.exec_params(query, params)
    end
  end
end

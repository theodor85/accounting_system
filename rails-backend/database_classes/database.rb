require 'pg'


module Database
  class Database
    def initialize(name, connection)
      @name = name.downcase
      @connection = connection
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

module Database
  class Database
    def initialize(name, connection)
      @connection = connection
      @name = @connection.quote_ident(name.downcase)
    end

    def create
      query = "CREATE DATABASE #{@name};"
      @connection.exec(query)
    end

    def drop
      query = "DROP DATABASE #{@name};"
      @connection.exec(query)
    end
  end
end

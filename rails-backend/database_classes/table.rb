require 'pg'


module Database
  class Table
    include Dry::Effects.Reader(:connection)

    def initialize(table_name)
      @table_name = table_name.downcase
    end

    def exists?
      query ="
        SELECT EXISTS (
          SELECT FROM information_schema.tables 
          WHERE table_name = '#{@table_name}'
          );
      "
      connection.exec(query) do |result|
        return result[0].values_at('exists')[0] == "t"
      end
    end

    def drop
      query ="DROP TABLE #{@table_name};"
      connection.exec(query)
    rescue PG::UndefinedTable
      raise UndefinedTable
    end

    def has_column? column_name
      query = "
        SELECT EXISTS (
          SELECT FROM information_schema.columns 
          WHERE table_name = '#{@table_name}' and column_name='#{column_name.downcase}'
        );
      "
      connection.exec(query) do |result|
        return result[0].values_at('exists')[0] == "t"
      end
    end

    def type_of_column column_name
      query = "
        SELECT data_type FROM information_schema.columns 
          WHERE table_name = '#{@table_name}' and column_name='#{column_name.downcase}';
      "
      connection.exec(query) do |result|
        return result[0].values_at('data_type')[0]
      end
    end
  end

  class UndefinedTable < StandardError
    def initialize(msg="This table not found")
      super
    end
  end
end

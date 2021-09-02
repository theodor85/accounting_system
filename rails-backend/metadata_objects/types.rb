require '/app/database_classes/connection'


module Metadata
  module Types
    def self.get_types_list(connection = nil)
      if connection
        get_types_list_from_db(connection)
      else
        Rails.configuration.connection_pool.with do |conn|
          get_types_list_from_db(conn)
        end
      end
    end

    private

    def self.get_types_list_from_db(connection)
      types_list = []

      query = "SELECT get_types_list();"
      connection.exec(query) do |result|
        result.each do |row|
          types_list << row.values_at('get_types_list')[0]
        end
      end
      types_list
    rescue PG::RaiseException => e
      raise GettingTypesListException.new(
        "Error while types list getting. Message: #{e.message}"
      )
    end

    class GettingTypesListException< StandardError
      def initialize(msg="Error while types list getting")
        super
      end
    end
  end
end

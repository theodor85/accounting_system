require '/app/database_classes/connection'


module Metadata
  class Types
    include Dry::Effects.Reader(:connection)

    def get_types_list
        get_types_list_from_db(connection)
    end

    private

    def get_types_list_from_db(conn)
      types_list = []

      query = "SELECT get_types_list();"
      conn.exec(query) do |result|
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
  end

  class GettingTypesListException < StandardError
    def initialize(msg="Error while types list getting")
      super
    end
  end
end

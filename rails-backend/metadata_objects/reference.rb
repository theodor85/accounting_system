# frozen_string_literal: true

require 'json'

module Metadata
  module References
    # Working with references
    class Reference
      include Dry::Effects.Reader(:connection)

      attr_reader :ref_name
      attr_reader :fields

      def initialize(ref_name)
        @ref_name = ref_name.downcase
        @fields = []
      end

      def create
        query = "CALL create_reference($1::text, $2::json);"
        params = [
          @ref_name,
          @fields.to_json
        ]
        connection.exec_params(query, params)
      rescue PG::RaiseException => e
        raise CreatingReferenceException.new(
          "Error while reference creating. Message: #{e.message}"
        )
      end

      def add_field(name:, type:)
        @fields << { name: name, type: type }
      end

      def fetch
        query = "SELECT get_reference($1::text);"
        params = [ @ref_name ]
        connection.exec_params(query, params) do |result|
          result.each do |row|
            @fields << { name: row.values_at('name')[0], type: row.values_at('type')[0] }
          end
        end
      rescue PG::RaiseException => e
        raise GettingReferenceException.new(
          "Error while reference getting. Message: #{e.message}"
        )
      end

      def delete
        query = "CALL delete_reference($1::text);"
        params = [ @ref_name ]
        connection.exec_params(query, params) 
      end
    end

    class CreatingReferenceException < StandardError
      def initialize(msg="Error while reference creating")
        super
      end
    end

    class GettingReferenceException < StandardError
      def initialize(msg="Error while reference getting")
        super
      end
    end
  end
end

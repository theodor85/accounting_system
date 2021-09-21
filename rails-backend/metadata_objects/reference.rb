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

    class ReferencesList
      include Dry::Effects.Reader(:connection)

      def fetch
        ref_list = []

        query = "SELECT get_references_list();"
        connection.exec(query) do |result|
          result.each do |row|
            ref_list << Reference.new(row.values_at('get_references_list')[0])
          end
        end
        ref_list
      rescue PG::RaiseException => e
        raise FetchingReferencesListException.new(
          "Error while fething references list from database. Message: #{e.message}"
        )
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

    class FetchingReferencesListException < StandardError
      def initialize(msg="Error while fething references list from database")
        super
      end
    end
  end
end

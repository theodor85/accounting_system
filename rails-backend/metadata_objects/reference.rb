# frozen_string_literal: true

require 'json'

module Metadata
  module References
    # Working with references
    class Reference
      include Dry::Effects.Reader(:connection)

      attr_accessor :ref_name
      attr_reader :ref_id
      attr_reader :fields

      def initialize
        @ref_name = nil
        @ref_id = nil
        @fields = []
      end

      def add_field(name:, type:)
        @fields << { name: name, type: type }
      end

      def create
        query = "CALL create_reference($1::text, $2::json);"
        params = [
          @ref_name,
          @fields.to_json
        ]
        connection.exec_params(query, params)

        fetch_by_name
      rescue PG::RaiseException => e
        raise CreatingReferenceException.new(
          "Error while reference creating. Message: #{e.message}"
        )
      end

      def find_by_name(ref_name)
        @ref_name = ref_name
        fetch_by_name
      end

      def find_by_id(ref_id)
        @ref_id = ref_id
        fetch_by_id
      end

      def delete
        query = "CALL delete_reference($1::text);"
        params = [ @ref_name ]
        connection.exec_params(query, params) 
      end

      private

      def fetch_by_name
        query = "SELECT get_reference_by_name($1::text);"
        params = [ @ref_name ]

        @fields.clear

        connection.exec_params(query, params) do |result|
          @ref_id = result[0]['get_reference_by_name'][1..-2].split(',')[0].to_i
          @ref_name = result[0]['get_reference_by_name'][1..-2].split(',')[1][1..-2]
          result.each do |row|
            @fields << {
              name: row['get_reference_by_name'][1..-2].split(',')[2],
              type: row['get_reference_by_name'][1..-2].split(',')[3]
            }
          end
        end
      rescue PG::RaiseException => e
        raise GettingReferenceException.new(
          "Error while reference getting. Message: #{e.message}"
        )
      end

      def fetch_by_id
        query = "SELECT get_reference_by_id($1::int);"
        params = [ @ref_id ]

        @fields.clear

        connection.exec_params(query, params) do |result|
          @ref_id = result[0]['get_reference_by_id'][1..-2].split(',')[0].to_i
          @ref_name = result[0]['get_reference_by_id'][1..-2].split(',')[1][1..-2]
          result.each do |row|
            @fields << {
              name: row['get_reference_by_id'][1..-2].split(',')[2],
              type: row['get_reference_by_id'][1..-2].split(',')[3]
            }
          end
        end
      rescue PG::RaiseException => e
        raise GettingReferenceException.new(
          "Error while reference getting. Message: #{e.message}"
        )
      end
    end

    class ReferencesList
      include Dry::Effects.Reader(:connection)

      def fetch
        ref_list = []

        query = "SELECT get_references_list();"
        connection.exec(query) do |result|
          result.each do |row|
            ref = Reference.new
            ref.find_by_name(row.values_at('get_references_list')[0])
            ref_list << ref
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

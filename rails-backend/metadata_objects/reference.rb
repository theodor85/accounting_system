# frozen_string_literal: true

require 'json'

module Metadata
  module References
    # Working with references
    class Reference
      attr_reader :ref_name
      attr_reader :fields

      def initialize(ref_name, connection = nil)
        @ref_name = ref_name.downcase
        @connection = connection
        @fields = []
      end

      def create
        if @connection
          _create(@connection)
        else
          Rails.configuration.connection_pool.with do |conn|
            _create(conn)
          end
        end
      end

      def add_field(name:, type:)
        @fields << { name: name, type: type }
      end

      def fetch
        if @connection
          _fetch(@connection)
        else
          Rails.configuration.connection_pool.with do |conn|
            _fetch(conn)
          end
        end
      end

      def delete
        if @connection
          _delete(@connection)
        else
          Rails.configuration.connection_pool.with do |conn|
            _delete(conn)
          end
        end
      end

      private

      def _create(connection)
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

      def _fetch(connection)
        query = "SELECT get_reference($1::text);"
        params = [ @ref_name ]
        @connection.exec_params(query, params) do |result|
          result.each do |row|
            @fields << { name: row.values_at('name')[0], type: row.values_at('type')[0] }
          end
        end
      rescue PG::RaiseException => e
        raise GettingReferenceException.new(
          "Error while reference getting. Message: #{e.message}"
        )
      end

      def _delete(connection)
        query = "CALL delete_reference($1::text);"
        params = [ @ref_name ]
        @connection.exec_params(query, params) 
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

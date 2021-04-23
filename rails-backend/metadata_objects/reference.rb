# frozen_string_literal: true

require 'json'

module Metadata
  module References
    # Working with references
    class Reference
      def initialize(ref_name, connection)
        @ref_name = ref_name.downcase
        @connection = connection
        @fields = []
      end

      def create
        query = "
          SELECT
            create_reference($1::text, $2::json);
        "
        params = [
          @ref_name,
          @fields.to_json
        ]
        @connection.exec_params(query, params)
      end

      def add_field(name:, type:)
        @fields << { name: name, type: type }
      end
    end
  end
end

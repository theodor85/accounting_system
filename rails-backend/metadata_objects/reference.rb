# frozen_string_literal: true

require 'pg'
require 'json'

# Класс для работы со справочниками
class Reference
  def initialize(ref_name)
    @ref_name = ref_name.downcase
    @connection = PG.connect(
      dbname: ENV['POSTGRES_DB_TEST'],
      user: ENV['POSTGRES_USER'],
      password: ENV['POSTGRES_PASSWORD_TEST'],
      host: ENV['POSTGRES_HOST']
    )
    @fields = []
  end

  def create
    query = "
      SELECT
        create_reference($1::text, $2::json);
    "
    params = [
      @ref_name,
      @fields.to_json,
    ]
    @connection.exec_params(query, params)
  end

  def add_field(name:, type:)
    @fields << { name: name, type: type }
  end
end

require 'pg'
require 'json'

class Reference
  def initialize(ref_name)
    @ref_name = ref_name.downcase
    @connection = PG.connect(
      dbname: ENV['POSTGRES_DB_TEST'],
      user: ENV['POSTGRES_USER'],
      password: ENV['POSTGRES_PASSWORD_TEST'],
      host: ENV['POSTGRES_HOST'],
    )
    @fields = []
  end

  def create
    query = "
      SELECT 
        create_reference('#{@ref_name}'::text, '#{@fields.to_json}'::json);
    "
    @connection.exec(query)
  end

  def add_field(name:, type:)
    @fields << {:name => name, :type => type}
  end
end

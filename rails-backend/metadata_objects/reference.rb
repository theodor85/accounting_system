require 'pg'

class Reference
  def initialize(ref_name)
    @ref_name = ref_name.downcase
    @connection = PG.connect(
      dbname: ENV['POSTGRES_DB_TEST'],
      user: ENV['POSTGRES_USER'],
      password: ENV['POSTGRES_PASSWORD_TEST'],
      host: ENV['POSTGRES_HOST'],
    )
  end

  def create
    query = "
      SELECT 
        create_reference('#{@ref_name}');
    "
    @connection.exec(query)
  end
end

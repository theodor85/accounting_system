require './database_classes/database'
require './database_classes/connection'


module DatabaseHelper
  def create_test_database()
    connection = ::Database::Connection.new.get_connection
    db = ::Database::Database.new(
      ENV['POSTGRES_DB_TEST'],
      connection,
    )
    db.create

    apply_sql_scripts(connection)

    connection.close
  end

  def drop_test_database()
    connection = ::Database::Connection.new.get_connection
    db = ::Database::Database.new(
      ENV['POSTGRES_DB_TEST'],
      connection,
    )
    db.drop
    connection.close
  end
end

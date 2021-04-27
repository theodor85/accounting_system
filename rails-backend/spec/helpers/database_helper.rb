require 'pathname'

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
    connection.close

    test_connection = ::Database::Connection.new.get_test_connection
    apply_sql_scripts(test_connection)
    test_connection.close
  end

  def apply_sql_scripts(connection)
    stored_procedures_dir = Pathname.new("/stored_procedures")
    Dir.foreach(stored_procedures_dir.to_s) do |item|
      sql_file = stored_procedures_dir + Pathname.new(item)

      connection.exec(
        File.open(sql_file.to_s, 'rb') { |file| file.read }
      )
    end
  end

  def remove_test_database()
    connection = ::Database::Connection.new.get_connection
    db = ::Database::Database.new(
      ENV['POSTGRES_DB_TEST'],
      connection,
    )
    db.drop
    connection.close
  end
end

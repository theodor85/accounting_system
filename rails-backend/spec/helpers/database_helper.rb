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
    Dir.each_child(stored_procedures_dir.to_s) do |item|
      sql_file = stored_procedures_dir + Pathname.new(item)

      connection.exec(
        File.open(sql_file.to_s, 'rb') { |file| file.read }
      )
    end
  end

  def remove_test_database()
    connection = ::Database::Connection.new.get_connection

    close_all_connections(ENV['POSTGRES_DB_TEST'], connection)

    db = ::Database::Database.new(
      ENV['POSTGRES_DB_TEST'],
      connection,
    )
    db.drop
    connection.close
  end

  def close_all_connections(database_name, connection)
    query = "
      SELECT 
        pg_terminate_backend(pid) 
      FROM 
        pg_stat_activity 
      WHERE 
        -- don't kill my own connection!
        pid <> pg_backend_pid()
        -- don't kill the connections to other databases
        AND datname = '#{database_name}'
      ;
    "
    connection.exec(query)
  end
end

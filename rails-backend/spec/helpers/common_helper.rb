require './database_classes/connection'


module CommonHelper
  def list_of_metadata_types
    connection = ::Database::Connection.new.get_test_connection

    query = "
      SELECT type_md
      FROM   md_types;
    "
    types_list = []
    connection.exec(query) do |result|
      result.each do |row|
        types_list << row.values_at('type_md')[0]
      end
    end

    connection.close
    return types_list
  end
end

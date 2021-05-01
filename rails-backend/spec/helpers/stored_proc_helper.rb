require './database_classes/connection'


module StoredProcHelper
  def create_reference(ref_name, fields)
    connection = ::Database::Connection.new.get_test_connection
    
    query = "
      CALL create_reference($1::text, $2::json);
    "
    params = [
      ref_name,
      fields.to_json
    ]
    connection.exec_params(query, params)
    connection.close
  end
end

require './database_classes/connection'


module ReferenceHelper
  def is_ref_in_md_refs?(ref_name)
    connection = ::Database::Connection.new.get_test_connection

    query = "
      SELECT COUNT(*)
      FROM md_refs
      WHERE ref_name like '#{ref_name}';
    "
    answer = false
    connection.exec(query) do |result|
      answer = result[0].values_at('count')[0].to_i >= 1
    end

    connection.close
    return answer
  end

  def is_fields_in_md_refs_fields?(ref_name, fields)
    connection = ::Database::Connection.new.get_test_connection

    query = "
      SELECT refs.ref_name, name, type
      FROM md_refs_fields
      JOIN md_refs as refs
      ON md_refs_fields.ref = refs.id
      WHERE refs.ref_name='#{ref_name}'
      ORDER BY name ASC;
    "

    sorted_fields = fields.sort{|a, b| a[:name] <=> b[:name]}

    answer = connection.exec(query) do |result|
      sorted_fields.each_with_index.all? do |field, i|
        result[i].values_at('ref_name')[0] == ref_name &&
          field[:name] == result[i].values_at('name')[0] &&
          field[:type] == result[i].values_at('type')[0]
      end
    end

    connection.close
    return answer
  end

  def get_ref_table_name(ref_name)
    connection = ::Database::Connection.new.get_test_connection

    query = "
      SELECT table_name
      FROM md_refs
      WHERE ref_name = '#{ref_name}';
    "
    table_name = connection.exec(query) do |result|
      result[0].values_at('table_name')[0]
    end
  end
end

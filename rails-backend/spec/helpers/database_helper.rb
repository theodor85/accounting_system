require './database_classes/database'


module DatabaseHelper
  def create_test_database(test_database_name)
    ::Database::Database.new(test_database_name).create
  end

  def drop_test_database(test_database_name)
    ::Database::Database.new(test_database_name).drop
  end
end

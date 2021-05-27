require 'rails_helper'
require './metadata_objects/reference'
require './database_classes/table'
require './database_classes/connection'

RSpec.describe 'Reference testing: ' do

  REF_NAME = 'Test reference'

  before(:all) do
    create_test_database()
    @connection = ::Database::Connection.new.get_test_connection
  end

  after(:all) do
    @connection.close
    remove_test_database()
  end

  describe ::Metadata::References::Reference do
    it 'can create reference and fetch metadata' do
      ref1 = ::Metadata::References::Reference.new(REF_NAME, @connection)
      ref1.add_field(name: 'customer', type: 'string')
      ref1.add_field(name: 'amount', type: 'number')
      ref1.add_field(name: 'description', type: 'text')
      ref1.create
  
      ref2 = ::Metadata::References::Reference.new(REF_NAME, @connection)
      ref2.fetch
  
      expect(ref1.ref_name).to             eq(ref2.ref_name)
      expect(ref1.fields[0]['name']).to    eq(ref2.fields[0]['name'])
      expect(ref1.fields[0]['type']).to    eq(ref2.fields[0]['type'])
      expect(ref1.fields[1]['name']).to    eq(ref2.fields[1]['name'])
      expect(ref1.fields[1]['type']).to    eq(ref2.fields[1]['type'])
      expect(ref1.fields[2]['name']).to    eq(ref2.fields[2]['name'])
      expect(ref1.fields[2]['type']).to    eq(ref2.fields[2]['type'])
    end
  end

  describe 'stored procedures testing:' do
    it 'create_reference should create metadata and database table' do
      
      ref_name = 'test ref'
      fields = [
        {:name => 'customer', :type => 'string'},
        {:name => 'amount', :type => 'number'},
        {:name => 'description', :type => 'text'},
      ]
      create_reference(ref_name, fields)
      
      # изменения в метаданных
      # добавлена строка в md_refs?
      expect(is_ref_in_md_refs?(ref_name)).to  be true

      # добавлены строки в md_refs_fields?
      expect(is_fields_in_md_refs_fields?(ref_name, fields)).to  be true

      # добавлена таблица c нужными полями?
      table = ::Database::Table.new(get_ref_table_name(ref_name), @connection)
      expect(table.exists?).to                       be true
      expect(table.has_column?('customer')).to       be true
      expect(table.has_column?('amount')).to         be true
      expect(table.type_of_column('customer')).to    eq('character varying')
      expect(table.type_of_column('amount')).to      eq('numeric')
      expect(table.type_of_column('description')).to eq('text')
    end
  end
end

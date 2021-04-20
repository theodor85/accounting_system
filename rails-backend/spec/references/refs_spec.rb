require 'rails_helper'
require './metadata_objects/reference'
require './database_classes/table'

RSpec.describe ::Metadata::References::Reference do

  REF_NAME = 'Anything'

  after(:each) do
    ::Database::Table.new(REF_NAME).drop
  rescue UndefinedTable
    puts "Таблица #{REF_NAME} не найдена"
  end

  it "can create database table with columns" do
    
    # include ::Metadata::References
    
    new_ref = ::Metadata::References::Reference.new(REF_NAME)
    new_ref.add_field(name: 'customer', type: 'string')
    new_ref.add_field(name: 'amount', type: 'number')
    new_ref.add_field(name: 'description', type: 'text')
    new_ref.create

    table = ::Database::Table.new(REF_NAME)
    expect(table.exists?).to                       be true
    expect(table.has_column?('customer')).to       be true
    expect(table.has_column?('amount')).to         be true
    expect(table.type_of_column('customer')).to    eq('character varying')
    expect(table.type_of_column('amount')).to      eq('numeric')
    expect(table.type_of_column('description')).to eq('text')
  end

  # it "can read metadata from database" do
  #   new_ref = Reference.new(REF_NAME)
  #   new_ref.add_field(name: 'customer', type: 'string')
  #   new_ref.add_field(name: 'amount', type: 'number')
  #   new_ref.add_field(name: 'description', type: 'text')
  #   new_ref.create

  #   check_ref = Reference.new(REF_NAME)

  #   expect(check_ref.ref_name).to  eq(REF_NAME)
  #   expect(check_ref.fields[0]['name']).to eq('customer')
  #   expect(check_ref.fields[0]['type']).to eq('string')
  #   expect(check_ref.fields[1]['name']).to eq('amount')
  #   expect(check_ref.fields[1]['type']).to eq('number')
  #   expect(check_ref.fields[2]['name']).to eq('description')
  #   expect(check_ref.fields[2]['type']).to eq('text')
  # end

  # it "can read update metadata" do
  #   new_ref = Reference.new(REF_NAME)
  #   new_ref.add_field(name: 'customer', type: 'string')
  #   new_ref.add_field(name: 'amount', type: 'number')
  #   new_ref.add_field(name: 'description', type: 'text')
  #   new_ref.create
  # end
end

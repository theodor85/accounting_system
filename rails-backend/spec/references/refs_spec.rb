require 'rails_helper'
require './metadata_objects/reference.rb'
require './database_classes/table.rb'

RSpec.describe Reference do

  TABLE_NAME = 'Anything'

  after(:each) do
    Table.new(TABLE_NAME).drop
  rescue UndefinedTable
    puts "Таблица #{TABLE_NAME} не найдена"
  end

  it "can create database table" do
    Reference.new(TABLE_NAME).create
    expect(Table.new(TABLE_NAME).exists?).to be true
  end

  it "can create database table with columns" do
    new_ref = Reference.new(TABLE_NAME)
    new_ref.add_field(name: 'customer', type: 'string')
    new_ref.add_field(name: 'amount', type: 'number')
    new_ref.add_field(name: 'description', type: 'text')
    new_ref.create

    table = Table.new(TABLE_NAME)
    expect(table.exists?).to                       be true
    expect(table.has_column?('customer')).to       be true
    expect(table.has_column?('amount')).to         be true
    expect(table.type_of_column('customer')).to    eq('character varying')
    expect(table.type_of_column('amount')).to      eq('numeric')
    expect(table.type_of_column('description')).to eq('text')
  end
end

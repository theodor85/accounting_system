require 'rails_helper'
require './metadata_objects/reference'
require './database_classes/table'
require './database_classes/connection'

RSpec.describe ::Metadata::References::Reference do

  REF_NAME = 'Test reference'

  before(:all) do
    create_test_database()
  end

  after(:all) do
    remove_test_database()
  end

  it 'can create reference and fetch metadata' do

    connection = ::Database::Connection.new.get_test_connection
    ref1 = ::Metadata::References::Reference.new(REF_NAME, connection)
    ref1.add_field(name: 'customer', type: 'string')
    ref1.add_field(name: 'amount', type: 'number')
    ref1.add_field(name: 'description', type: 'text')
    ref1.create

    ref2 = ::Metadata::References::Reference.new(REF_NAME)
    ref2.refresh

    expect(ref1.ref_name).to             eq(ref2.ref_name)
    expect(ref1.fields[0]['name']).to    eq(ref2.fields[0]['name'])
    expect(ref1.fields[0]['type']).to    eq(ref2.fields[0]['type'])
    expect(ref1.fields[1]['name']).to    eq(ref2.fields[1]['name'])
    expect(ref1.fields[1]['type']).to    eq(ref2.fields[1]['type'])
    expect(ref1.fields[2]['name']).to    eq(ref2.fields[2]['name'])
    expect(ref1.fields[2]['type']).to    eq(ref2.fields[2]['type'])
    connection.close
  end
end

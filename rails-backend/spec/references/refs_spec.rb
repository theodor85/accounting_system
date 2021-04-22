require 'rails_helper'
require './metadata_objects/reference'
require './database_classes/table'

RSpec.describe ::Metadata::References::Reference do

  REF_NAME = 'Test reference'

  before(:all) do
    create_test_database(ENV['POSTGRES_DB_TEST'])
  end

  after(:all) do
    remove_test_database(ENV['POSTGRES_DB_TEST'])
  end

  it 'can create reference and fetch metadata' do

    # include ::Metadata::References

    ref1 = ::Metadata::References::Reference.new(REF_NAME)
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
  end
end

require 'rails_helper'
require './metadata_objects/reference.rb'
require './database_classes/table.rb'

RSpec.describe Reference do

  TABLE_NAME = 'Anything'

  after(:each) do
    Table.new(TABLE_NAME).drop
  end

  it "can create database table" do
    Reference.new(TABLE_NAME).create
    expect(Table.new(TABLE_NAME).exists?).to be true
  end
end

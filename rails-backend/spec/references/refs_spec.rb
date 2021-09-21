require 'rails_helper'
require './metadata_objects/reference'
require './database_classes/table'

RSpec.describe 'Reference testing: ' do

  ref_name = 'Test reference'

  describe ::Metadata::References::Reference do
    it 'can create reference and fetch metadata' do
      ref1 = ::Metadata::References::Reference.new(ref_name)
      ref1.add_field(name: 'customer', type: 'string')
      ref1.add_field(name: 'amount', type: 'number')
      ref1.add_field(name: 'description', type: 'text')
      ref1.create
  
      ref2 = ::Metadata::References::Reference.new(ref_name)
      ref2.fetch
  
      expect(ref1.ref_name).to             eq(ref2.ref_name)
      expect(ref1.fields[0]['name']).to    eq(ref2.fields[0]['name'])
      expect(ref1.fields[0]['type']).to    eq(ref2.fields[0]['type'])
      expect(ref1.fields[1]['name']).to    eq(ref2.fields[1]['name'])
      expect(ref1.fields[1]['type']).to    eq(ref2.fields[1]['type'])
      expect(ref1.fields[2]['name']).to    eq(ref2.fields[2]['name'])
      expect(ref1.fields[2]['type']).to    eq(ref2.fields[2]['type'])
    end

    it 'can delete reference' do
      ref1 = ::Metadata::References::Reference.new('test delete ref')
      ref1.add_field(name: 'customer', type: 'string')
      ref1.create

      ref1.delete

      expect { ref1.fetch }.to raise_error(::Metadata::References::GettingReferenceException)
    end
  end

  describe 'stored procedures testing:' do
    it 'create_reference should create metadata and database table' do
      

      fields = [
        {name: 'customer', type: 'string'},
        {name: 'amount', type: 'number'},
        {name: 'description', type: 'text'},
      ]

      ref1 = ::Metadata::References::Reference.new('ref_name')
      ref1.add_field(**fields[0])
      ref1.add_field(**fields[1])
      ref1.add_field(**fields[2])
      ref1.create

      # изменения в метаданных
      # добавлена строка в md_refs?
      expect(is_ref_in_md_refs?('ref_name')).to  be true

      # добавлены строки в md_refs_fields?
      expect(is_fields_in_md_refs_fields?('ref_name', fields)).to  be true

      # добавлена таблица c нужными полями?
      table = ::Database::Table.new(get_ref_table_name('ref_name'))
      expect(table.exists?).to                       be true
      expect(table.has_column?('customer')).to       be true
      expect(table.has_column?('amount')).to         be true
      expect(table.type_of_column('customer')).to    eq('character varying')
      expect(table.type_of_column('amount')).to      eq('numeric')
      expect(table.type_of_column('description')).to eq('text')
    end
  end

  describe ::Metadata::References::ReferencesList do
    
    let(:ref_names) {['test ref 01', 'test ref 02', 'test ref 03']}

    it 'can fetch list of references' do
      ref1 = ::Metadata::References::Reference.new(ref_names[0])
      ref1.add_field(name: 'customer', type: 'string')
      ref1.add_field(name: 'amount', type: 'number')
      ref1.add_field(name: 'description', type: 'text')
      ref1.create

      ref2 = ::Metadata::References::Reference.new(ref_names[1])
      ref2.add_field(name: 'employes', type: 'string')
      ref2.add_field(name: 'salary', type: 'number')
      ref2.add_field(name: 'age', type: 'number')
      ref2.create

      ref3 = ::Metadata::References::Reference.new(ref_names[2])
      ref3.add_field(name: 'goods', type: 'string')
      ref3.add_field(name: 'amount', type: 'number')
      ref3.add_field(name: 'description', type: 'text')
      ref3.create

      ref_list = described_class.new.fetch

      expect(ref_list.length).to       eq(3)
      expect(ref_list[0].ref_name).to  eq('test ref 01')
      expect(ref_list[1].ref_name).to  eq('test ref 02')
      expect(ref_list[2].ref_name).to  eq('test ref 03')
    end
  end
end

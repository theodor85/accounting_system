require 'rails_helper'
require './metadata_objects/types'

RSpec.describe 'Types testing: ' do
  it 'getting types list' do
    types_list = ::Metadata::Types.get_types_list(@connection)

    expect(types_list.length).to     eq(list_of_metadata_types.length)
    expect(types_list).to            include(*list_of_metadata_types)
  end
end

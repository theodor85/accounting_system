require '/app/metadata_objects/types'


class ReferenceController < ApplicationController
  def new
    @types_list = ::Metadata::Types.get_types_list
  end

  def create
  end
end

require '/app/metadata_objects/types'
require '/app/metadata_objects/reference'


class ReferenceController < ApplicationController
  def new
    @types_list = session[:types_list] || ::Metadata::Types.get_types_list
    session[:types_list] = @types_list
  end

  def create
    puts params

  end
end

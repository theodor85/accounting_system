require '/app/metadata_objects/types'


class ReferenceController < ApplicationController
  def new
    @ref_name = session[:ref_name] || ''
    @types_list = session[:types_list] || ::Metadata::Types.get_types_list
    session[:types_list] = @types_list
    @fields = session[:fields] || []
    session[:fields] = @fields
  end

  def create
  end
end

require '/app/metadata_objects/types'
require '/app/metadata_objects/reference'


class ReferenceController < ApplicationController
  def new
    @types_list = session[:types_list] || ::Metadata::Types.new.get_types_list
    session[:types_list] = @types_list
  end

  def create
    fields = get_fields_from_params(params)

    ref = ::Metadata::References::Reference.new(params['ref_name'])
    fields.each do |field |
      ref.add_field(**field)
    end
    ref.create

    redirect_to conf_path
  rescue ::Metadata::References::CreatingReferenceException => e
    flash.alert = e.message
    redirect_to conf_refs_add_path
  end

  private

  def get_fields_from_params(params)
    fields = []
    params.each_pair do |key, value|
      if key[0..9] == 'field_name'
        index = key[10..11]
        fields << {:name => value, :type => params['field_type' + index]}
      end
    end
    fields
  end
end

# frozen_string_literal: true

class ReferenceReflex < ApplicationReflex
  def new_field(fields)
    # session[:fields] = fields
    session[:fields] << {:name => '', :type => nil}
  end

  def remove_field(index)
    session[:fields].delete_at(index)
  end
end

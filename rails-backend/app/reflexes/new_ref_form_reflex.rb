class NewRefFormReflex < ApplicationReflex
  def get
    @new_ref_form = render partial: 'new_ref'
  end
end

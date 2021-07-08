class NewRefFormReflex < ApplicationReflex
  def get(reject)
    @reject = ActiveModel::Type::Boolean.new.cast(reject)
    if @reject
      session[:button_text] = 'Добавить справочник'
      session[:new_ref_form] = ''
      session[:reject] = false
    else
      session[:button_text] = 'Отменить добавление'
      session[:new_ref_form] = render partial: 'new_ref'
      session[:reject] = true
    end
  end
end

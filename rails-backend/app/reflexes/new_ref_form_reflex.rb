class NewRefFormReflex < ApplicationReflex
  def get
    @reject = ActiveModel::Type::Boolean.new.cast(element.dataset[:reject])
    if @reject
      @button_text = 'Добавить справочник'
      @new_ref_form = ''
      @reject = false
    else
      @button_text = 'Отменить добавление'
      @new_ref_form = render partial: 'new_ref'
      @reject = true
    end
  end
end

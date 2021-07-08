class ConfiguratorController < ApplicationController
  def index
    @button_text = session[:button_text]
    @new_ref_form = session[:new_ref_form]
    @reject = session[:reject]
  end
end

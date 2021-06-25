class ConfiguratorController < ApplicationController
  def index
  end

  def new_ref
    render partial: 'new_ref'
  end
end

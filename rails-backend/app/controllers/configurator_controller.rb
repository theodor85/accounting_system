require '/app/metadata_objects/reference'


class ConfiguratorController < ApplicationController
  def index
    @references = []
    @references << ::Metadata::References::Reference.new('qwerty')
    @references << ::Metadata::References::Reference.new('asdfg')
    @references << ::Metadata::References::Reference.new('zxcvb')
  end
end

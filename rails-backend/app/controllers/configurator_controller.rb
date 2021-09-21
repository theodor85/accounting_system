require '/app/metadata_objects/reference'


class ConfiguratorController < ApplicationController
  def index
    @references = ::Metadata::References::ReferencesList.new.fetch
  end
end

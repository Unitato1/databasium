# frozen_string_literal: true

module Databasium
  class ModelFormComponent < ViewComponent::Base
    def initialize(columns_names_types:, model:, path: )
      @columns_names_types = columns_names_types
      @path = path
      @model = model
    end
  end
end

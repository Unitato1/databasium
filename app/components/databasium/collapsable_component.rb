# frozen_string_literal: true

module Databasium
  class CollapsableComponent < ViewComponent::Base
    def initialize(name:, form:, class_name: nil, data_targets: {})
      @name = name
      @form = form
      @class_name = class_name
      @data_targets = data_targets
    end
  end
end

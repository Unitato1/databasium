# frozen_string_literal: true

module Databasium
  class NavigationPanelElementComponent < ViewComponent::Base
    def initialize(icon:, text:)
      @icon = icon
      @text = text
    end
  end
end

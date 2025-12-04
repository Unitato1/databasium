# frozen_string_literal: true

module Databasium
  class NavigationPanelComponent < ViewComponent::Base
    def initialize(navigation_elements:, vertical:)
      @vertical = vertical
      @navigation_elements = navigation_elements
    end
  end
end

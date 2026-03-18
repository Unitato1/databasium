module Components
  module Databasium
    class Navigation::BaseIcon < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include ::Databasium::HeroiconHelper

      attr_reader :element

      def initialize(element:)
        @element = element
      end

      protected

      def icon_classes
        "flex justify-between items-center gap-2
          border-1 border-border p-1 px-3 rounded-xl cursor-pointer hover:border-hover"
      end

      def render_icon(icon)
         heroicon icon,
                     variant: :outline,
                     options: {
                       class: "w-4 h-4"
                     }
      end
    end
  end
end

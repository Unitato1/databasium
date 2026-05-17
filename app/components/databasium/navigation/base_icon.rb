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
        class_names(
          "flex justify-between items-center gap-2
          border-1 border-border p-1 px-3 rounded-xl cursor-pointer hover:border-hover",
          "bg-accent shadow-accent" => element[:active]
        )
      end

      def render_icon(icon)
        heroicon icon, variant: :outline, options: { class: "w-6 h-6" }
      end

      def render_text(text)
        p(class: "text-main-text text-base text-nowrap") { text }
      end
    end
  end
end

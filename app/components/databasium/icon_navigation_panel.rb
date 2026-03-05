# frozen_string_literal: true

module Components
  module Databasium
    class IconNavigationPanel < Components::Base
      def initialize(icons_with_text: [], vertical: nil)
        @icons_with_text = icons_with_text
        @vertical = vertical
      end

      def view_template(&block)
        form(&block)
      end

      private

      def form(&block)
        div(class: [ "w-fit align-items-center mb-4 justify-items-center", @vertical ? "flex"  : "flex-column" ], data: { controller: "hide" }) do
          @icons_with_text.each do |element|
            div(data: { hide: element[:text].to_s.split(" ").join("_"), action: "click->hide#hide" },
              class: "flex flex-col justify-between items-center border-2
                border-l-transparent first:border-l-2 first:border-gray-300
                border-gray-300 px-2 py-1 text-xs w-full text-center cursor-pointer hover:border-green-500"
              ) do
              raw helpers.heroicon element[:icon], variant: :outline, options: { class: "w-8 h-8" }

              div do
                p { element[:text] }
              end
            end
          end
        end
      end
    end
  end
end

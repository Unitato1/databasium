# frozen_string_literal: true

module Components
  module Databasium
    class Navigation::IconPanel < Components::Base
      include Phlex::Rails::Helpers::LinkTo

      # element format: { icon: "icon-name", text: "text", path: "path", method: :get | :post | frontend, turbo_frame: "frame_id" }
      def initialize(icons_with_text: [])
        @icons_with_text = icons_with_text
      end

      def view_template(&block)
        form(&block)
      end

      private

      def form(&block)
        div(class: "align-items-center justify-items-center flex gap-2") do
          @icons_with_text.each { |element| render Navigation::Icon.new(element: element) }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class Navigation::IconPanel < Components::Base
      include Phlex::Rails::Helpers::LinkTo

      # element format: { icon: "icon-name", text: "text", path: "path" }
      def initialize(icons_with_text: [])
        @icons_with_text = icons_with_text
      end

      def view_template(&block)
        form(&block)
      end

      private

      def form(&block)
        div(
          class: "align-items-center justify-items-center flex gap-2",
          data: {
            controller: "hide"
          }
        ) do
          @icons_with_text.each do |element|
            unless element[:path].present?
              div(
                class:
                  "flex justify-between items-center gap-2
                border-1 border-border p-1 px-3 rounded-xl cursor-pointer hover:border-green-500",
                data: {
                  hide: element[:text].to_s.split(" ").join("_"),
                  action: "click->hide#hide"
                }
              ) do
                raw helpers.heroicon element[:icon],
                                     variant: :outline,
                                     options: {
                                       class: "w-4 h-4"
                                     }

                p(class: "text-main-text text-base") { element[:text] }
              end
            end

            if element[:path].present?
              link_to(
                element[:path],
                class:
                  "flex justify-between items-center gap-2
              border-1 border-border p-1 px-3 rounded-xl cursor-pointer hover:border-green-500",
                data: {
                  turbo_method: :post,
                  turbo_frame: "_top"
                }
              ) do
                raw helpers.heroicon element[:icon],
                                     variant: :outline,
                                     options: {
                                       class: "w-4 h-4"
                                     }
                p(class: "text-main-text text-base") { element[:text] }
              end
            end
          end
        end
      end
    end
  end
end

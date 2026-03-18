module Components
  module Databasium
    class Navigation::Icon < Components::Base
      include Phlex::Rails::Helpers::LinkTo

      attr_reader :element

      def initialize(element:)
        @element = element
      end

      def view_template
        unless element[:path].present?
          div(
            class:
              "flex justify-between items-center gap-2
            border-1 border-border p-1 px-3 rounded-xl cursor-pointer hover:border-hover",
            data: {
              hide: element[:text].to_s.split(" ").join("_"),
              action: "click->hide#hide"
            }
          ) do
            heroicon element[:icon],
                         variant: :outline,
                         options: {
                           class: "w-4 h-4"
                         }

            p(class: "text-main-text text-base") { element[:text] }
          end
        else
          render Navigation::PostIcon.new(element: element)
          # link_to(
          #   element[:path],
          #   class:
          #     "flex justify-between items-center gap-2
          # border-1 border-border p-1 px-3 rounded-xl cursor-pointer hover:border-hover",
          #   data: {
          #     turbo_method: :post,
          #     turbo_frame: "_top"
          #   }
          # ) do
          #   raw helpers.heroicon element[:icon],
          #                        variant: :outline,
          #                        options: {
          #                          class: "w-4 h-4"
          #                        }
          #   p(class: "text-main-text text-base") { element[:text] }
          # end
        end
      end
    end
  end
end

module Components
  module Databasium
    class Navigation::FrontendIcon < Navigation::BaseIcon
      include Phlex::Rails::Helpers::LinkTo

      def initialize(element:)
        super(element: element)
      end

      def view_template
        div(
          class: icon_classes,
          data: {
            hide: element[:text].to_s.split(" ").join("_"),
            action: "click->hide#hide"
          }
        ) do
          render_icon(element[:icon])
          p(class: "text-main-text text-base") { element[:text] }
        end
      end
    end
  end
end

module Components
  module Databasium
    class Navigation::FrontendIcon < Navigation::BaseIcon
      def initialize(element:, data_params: {})
        super(element: element)
        @data_params = data_params
      end

      def view_template
        div(class: icon_classes, data: @data_params) do
          render_icon(element[:icon])
          p(class: "text-main-text text-base") { element[:text] }
        end
      end
    end
  end
end

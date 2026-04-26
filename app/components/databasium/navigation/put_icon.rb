module Components
  module Databasium
    class Navigation::PutIcon < Navigation::BaseIcon
      include Phlex::Rails::Helpers::LinkTo

      def initialize(element:)
        super(element: element)
      end

      def view_template
        link_to(element[:path], class: icon_classes, data: { turbo_method: :put }) do
          render_icon(element[:icon])
          p(class: "text-main-text text-base") { element[:text] }
        end
      end
    end
  end
end

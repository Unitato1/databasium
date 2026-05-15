module Components
  module Databasium
    class Navigation::GetIcon < Navigation::BaseIcon
      include Phlex::Rails::Helpers::LinkTo

      def initialize(element:, turbo_frame: nil)
        super(element: element)
        @turbo_frame = turbo_frame
      end

      def view_template
        link_to(
          element[:path],
          class: icon_classes,
          data: {
            turbo_method: :get,
            turbo_stream: true
          }
        ) do
          render_icon(element[:icon])
          render_text(element[:text])
        end
      end
    end
  end
end

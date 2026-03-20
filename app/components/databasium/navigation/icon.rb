module Components
  module Databasium
    class Navigation::Icon < Components::Base
      include Phlex::Rails::Helpers::LinkTo

      attr_reader :element

      def initialize(element:)
        @element = element
      end

      def view_template
        case element[:method]
        when :frontend
          render Navigation::FrontendIcon.new(element: element)
        when :get
          render Navigation::GetIcon.new(element: element, turbo_frame: element[:turbo_frame])
        when :post
          render Navigation::PostIcon.new(element: element)
        else
          p { "Please provide method to icon component" }
        end
      end
    end
  end
end

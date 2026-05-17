module Components
  module Databasium
    class Records::Sidebar < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize
      end

      def view_template
        div(class: "flex flex-col w-full") do
          render Components::Databasium::Forms::Search.new(
                   url: databasium.sidebar_records_path,
                   turbo_frame: "results",
                   placeholder: "Search for a table"
                 )
          turbo_frame_tag("results", src: databasium.sidebar_records_path) do
            p(class: "mt-2 animate-pulse") { "Loading tables..." }
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class Schemas::Sidebar< Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize
      end

      def view_template
        div(class: "flex flex-col gap-2", data: { controller: "search" }) do
          render Components::Databasium::Forms::Search.new(
            url: databasium.sidebar_schemas_path,
            turbo_frame: "results",
            placeholder: "Search for a model"
          )
          turbo_frame_tag("results", src: databasium.sidebar_schemas_path) do
            p(class: "mt-2 animate-pulse") { "Loading models..." }
          end
        end
      end
    end
  end
end

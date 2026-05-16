# frozen_string_literal: true

module Components
  module Databasium
    class Migrations::Sidebar < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize
      end

      def view_template
        div(class: "flex flex-col gap-2", data: { controller: "search" }) do
          render Components::Databasium::Forms::Search.new(
            url: databasium.sidebar_migrations_path,
            turbo_frame: "results",
            placeholder: "Search for a migration"
          )
          turbo_frame_tag("results", src: databasium.sidebar_migrations_path) do
            p(class: "mt-2 animate-pulse") { "Loading migrations..." }
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class Global::HeaderActions < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(actions: nil)
        @actions = actions
      end

      def view_template
        render_navigation_links
      end

      private

      def render_navigation_links
        div(
          class: "border-b-1 bg-panel border-border flex items-center text-2xl gap-4 py-2 ps-4"
        ) do
          div(
            class: "flex items-center gap-4 border-1 p-1 p-2 rounded-xl font-bold",
            data: {
              action: "click->layout#toggleSidebar"
            }
          ) { heroicon("arrows-right-left", variant: :outline, options: { class: "w-4 h-4" }) }
          div(id: "header_actions") { raw @actions }
        end
      end
    end
  end
end

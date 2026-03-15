# frozen_string_literal: true

module Components
  module Databasium
    class Global::HeaderActions < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Routes

      def initialize(actions: nil)
        @actions = actions
      end

      def view_template
        render_navigation_links
      end

      private
      def render_navigation_links
        nav(class: "border-b-1 bg-panel border-border flex items-center text-2xl gap-4 py-2 ps-4") do
          div(class: "flex items-center gap-4 border-1 p-1 p-2 rounded-xl font-bold", data: { action: "click->layout#toggleSidebar" }) do
            raw helpers.heroicon("arrows-right-left", variant: :outline, options: { class: "w-4 h-4" })
          end
          @actions&.each do |action|
            link_to(helpers.send(page[:path]), class: "not-last:border-e-1 border-border pe-4") do
               raw helpers.heroicon(action[:icon], variant: :outline, options: { class: "w-6 h-6" })
               span(class: "ml-2") { action[:text] }
            end
          end
        end
      end
    end
  end
end

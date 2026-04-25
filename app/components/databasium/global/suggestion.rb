# frozen_string_literal: true

module Components
  module Databasium
    class Global::Suggestion < Components::Base
      def initialize(suggestions:)
        @suggestions = suggestions
      end

      def view_template
        div(class: "flex flex-col gap-2 bg-panel border-1 border-border rounded-xl p-2 m-4", id: "suggestion") do
          @suggestions.each do |suggestion|
            div(class: "flex items-center gap-2") do
              heroicon("information-circle", variant: :outline, options: { class: "w-6 h-6" })
              span(class: "text-main-text") { suggestion }
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Views
  module Databasium
    class Models::Index < Views::Base
      include Phlex::Rails::Helpers::ContentFor

      def initialize(models:)
        @models = models
      end

      def view_template
        content_for(:title) { "Models" }

        div(class: "w-full h-full p-4") { render_models }
      end

      private

        def render_models
          div(
            class: "w-full h-full border-1 rounded-2xl p-4 overflow-x-auto",
          ) do @models.each do |model|
            div(class: "border-1 border-border rounded-xl p-4") do
              h2(class: "text-lg font-semibold mb-2") { model.name }
            end
          end
        end
      end
    end
  end
end

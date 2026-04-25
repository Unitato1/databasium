# frozen_string_literal: true

module Views
  module Databasium
    class Schemas::Index < Views::Base
      include Phlex::Rails::Helpers::ContentFor

      def initialize(schema:, models:, pagy:, model:, layers:)
        @schema = schema
        @models = models
        @pagy = pagy
        @model = model
        @layers = layers
      end

      def view_template
        content_for(:title) { "Schema" }
        content_for(:sidebar) do
          render Components::Databasium::Schemas::Sidebar.new(models: @models, pagy: @pagy)
        end
        if @model.present?
          content_for(:header_actions) do
            render Components::Databasium::Schemas::HeaderActions.new(
                     model: @model,
                     layers: @layers
                   )
          end
        end
        div(class: "w-full h-full p-4") { render_schema }
      end

      private

      def render_schema
        div(
          class: "w-full h-full border-1 border-border rounded-2xl p-4 overflow-x-auto",
          data: {
            controller: "graph",
            graph_tables_value: @schema.to_json
          }
        ) { }
      end
    end
  end
end

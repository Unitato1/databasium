# frozen_string_literal: true

module Views
  module Databasium
    class Schemas::Index < Views::Base
      include Phlex::Rails::Helpers::ContentFor

      def initialize(schema:)
        @schema = schema
      end

      def view_template
        content_for(:title) { "Schema" }

        div(class: "w-full h-full p-4") { render_schema }
      end

      private

      def render_schema
        div(
          class: "w-full h-full border-1 rounded-2xl p-4 overflow-x-auto",
          data: {
            controller: "graph",
            graph_tables_value: @schema.to_json
          }
        ) {}
      end
    end
  end
end

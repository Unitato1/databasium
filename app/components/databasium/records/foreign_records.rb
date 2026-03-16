# frozen_string_literal: true

module Components
  module Databasium
    class Records::ForeignRecords < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(model:, columns_names_types:)
        @model = model
        @columns_names_types = columns_names_types
      end

      def view_template
        turbo_frame_tag("foreign_records") do
          div(class: "relative") do
            div(
              class: "absolute z-10 bg-blue-100 p-4 rounded-xl border-1 border-blue-300 w-fit",
              id: "foreign_records",
              data: {
                table_select_target: "table"
              }
            ) do
              render_title
              render_filters
              render_table
            end
          end
        end
      end

      private

      def render_title
        div(class: "flex justify-between items-center mb-2 border-b-1 border-blue-300 pb-2 mb-2") do
          h1(class: "w-ful text-2xl font-bold") { "Records of #{@model_name}" }
          button(
            class: "text-blue-700 hover:text-blue-900",
            data: {
              action: "click->table-select#toggleVisibility"
            }
          ) { helpers.heroicon("x-mark", variant: :solid, options: { class: "w-8 h-8" }) }
        end
      end

      def render_filters
        render Records::Filter.new(
                 model: @model,
                 turbo_frame: "foreign_records_list",
                 columns_names_types: @columns_names_types,
                 hidden: false
               )
      end

      def render_table
        turbo_frame_tag "foreign_records_list",
                        class: "overflow-auto block",
                        src:
                          helpers.records_records_path(
                            table: @model&.name,
                            frame_id: "foreign_records_list",
                            lazy: true
                          ) { }
      end
    end
  end
end

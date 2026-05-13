# frozen_string_literal: true

module Components
  module Databasium
    class Records::ForeignRecords < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(model:, columns_names_types:, frame_id: nil)
        @model = model
        @columns_names_types = columns_names_types
        @frame_id = frame_id || "foreign_records_#{@model&.name}"
        @table_id = @frame_id.sub(/\Aforeign_records_/, "foreign_records_table_")
      end

      def view_template
        turbo_frame_tag(@frame_id) do
          div(
            class:
              "fixed inset-0 z-[9999] flex items-center justify-center bg-black/40 p-4",
            data: {
              table_select_target: "table",
              action: "click->table-select#dismiss"
            }
          ) do
            div(
              class:
                "relative bg-panel p-4 rounded-xl border-1 border-border w-fit max-w-[50vw] flex flex-col h-[90dvh] overflow-auto shadow-2xl",
              id: @frame_id,
              data: {
                action: "click->table-select#stopPropagation"
              }
            ) do
              render_title
              render_selected_record
              render_filters
              render_table
            end
          end
        end
      end

      private

      def render_selected_record
        div(class: "flex flex gap-2 items-center") do
          h2(class: "") { "Selected Record:" }
          p(class: "font-bold", data: { table_select_target: "selectedRecord" }) { "You haven't yet selected a record" }
        end
      end

      def render_title
        div(class: "flex justify-between items-center mb-2 border-b-1 border-border pb-2 mb-2") do
          h1(class: "w-ful text-2xl font-bold") { "Records of #{@model&.name}" }
          button(
            class: "text-accent hover:text-accent-dark",
            data: {
              action: "click->table-select#toggleVisibility"
            }
          ) { heroicon("x-mark", variant: :solid, options: { class: "w-8 h-8" }) }
        end
      end

      def render_filters
        render Records::Filter.new(
                 model: @model,
                 turbo_frame: @table_id,
                 columns_names_types: @columns_names_types,
                 hidden: false
               )
      end

      def render_table
        turbo_frame_tag @table_id,
                        class: "flex-1 min-h-0 overflow-auto block",
                        src:
                          helpers.records_records_path(
                            table: @model&.name,
                            frame_id: @table_id,
                            lazy: true
                          ) { }
      end
    end
  end
end

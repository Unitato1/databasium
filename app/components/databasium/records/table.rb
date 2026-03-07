# frozen_string_literal: true

module Components
  module Databasium
    class Records::Table < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(records:, model:, turbo_frame:, pagy: nil, feedback: nil)
        @records = records
        @model = model
        @turbo_frame = turbo_frame
        @pagy = pagy
        @feedback = feedback
      end

      def view_template
        turbo_frame_tag @turbo_frame do
          render_table
          render_pagy
        end
      end

      private

      def render_table
        if @feedback || !@model || @records.empty?
          div(
            class:
              "border-2 border-teal-500 text-center p-2 rounded-xl bg-teal-200 mx-auto w-fit text-gray-700 text-xl"
          ) { @feedback || "Select a table to view its records." }
        else
          table(class: "table-fixed border-2 border-gray-300 whitespace-nowrap min-w-max") do
            render_table_head
            render_table_body
          end
        end
      end

      def render_table_head
        thead do
          tr(class: "border-2 border-gray-300") do
            @model&.columns&.each do |column|
              th(class: "text-center w-55 max-w-55 py-2 border-2 border-gray-300 overflow-auto") do
                plain column.name
              end
            end
          end
        end
      end

      def render_table_body
        tbody(id: "#{@turbo_frame}_list") do
          if @records&.any?
            @records.each do |record|
              tr(
                class: "border-2 border-gray-300 hover:bg-gray-100 hover:cursor-pointer",
                data: {
                  action: "click->table-select#selectRecord",
                  record_id: record.id
                }
              ) do
                record.attributes.each do |_, value|
                  td(
                    class: "text-center w-55 max-w-55 py-2 border-2 border-gray-300 overflow-auto"
                  ) { plain format_cell_value(value) }
                end
              end
            end
          end
        end
      end

      def format_cell_value(value)
        case value
        when Time, DateTime, ActiveSupport::TimeWithZone
          value.strftime("%Y-%m-%d %H:%M:%S")
        when Date
          value.strftime("%Y-%m-%d")
        else
          value.to_s
        end
      end

      def render_pagy
        div(class: "mt-4 flex justify-start") { raw @pagy.series_nav.html_safe } if @pagy
      end
    end
  end
end

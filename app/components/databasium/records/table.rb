# frozen_string_literal: true

module Components
  module Databasium
    class Records::Table < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(records:, model:, turbo_frame:, pagy: nil, feedback: nil, columns_names_types:)
        @records = records
        @model = model
        @turbo_frame = turbo_frame
        @pagy = pagy
        @feedback = feedback
        @columns_names_types = columns_names_types
      end

      def view_template
        turbo_frame_tag(@turbo_frame) do
          div(class: "") do
            render_table
            render_pagy
          end
        end
      end

      private

      def render_table
        if @feedback || !@model || @records.empty?
          div(
            class:
              "bg-panel text-accent shadow-accent border-1 border-border text-center p-2 rounded-md mx-auto w-fit"
          ) { @feedback || "Select a table to view its records." }
        else
          render Components::Databasium::Records::Filter.new(
            model: @model,
            turbo_frame: "records",
            columns_names_types: @columns_names_types,
            hidden: true
          )
          render Components::Databasium::Forms::Model.new(
            columns_names_types: @columns_names_types,
            model: @model
          )
          div(class: "overflow-hidden rounded-xl border border-border w-fit") do
            table(class: "whitespace-nowrap min-w-max bg-panel border-collapse") do
              render_table_head
              render_table_body
            end
          end
        end
      end

      def render_table_head
        thead do
          tr(class: "bg-accent shadow-accent") do
            @model&.columns&.each do |column|
              th(class: "text-center w-55 max-w-55 py-2 border-1 border-border overflow-auto") do
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
                class: "hover:bg-background hover:cursor-pointer",
                data: {
                  action: "click->table-select#selectRecord",
                  record_id: record.id
                }
              ) do
                record.attributes.each do |_, value|
                  td(
                    class: "text-center w-55 max-w-55 py-2 border-1 border-border overflow-auto"
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

module Components
  module Databasium
    class Records::CleanTable < Components::Base
      def initialize(records:, model:, turbo_frame:, pagy: nil, feedback: nil, columns_names_types:)
        @records = records
        @model = model
        @turbo_frame = turbo_frame
        @pagy = pagy
        @feedback = feedback
        @columns_names_types = columns_names_types
      end

      def view_template
        div(id: "records_list", class: "flex min-h-0 min-w-0 flex-1 flex-col") do
          div(class: "flex-1 min-h-0 max-h-fit overflow-auto") do
          table(class: "whitespace-nowrap bg-panel min-w-max") do
              render_table_head
              render_table_body
            end
          end

          render_pagy
        end
      end

      private

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
        tbody() do
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
        div(class: "m-4 flex justify-start") { raw @pagy.series_nav.html_safe } if @pagy && @records&.any?
      end
    end
  end
end

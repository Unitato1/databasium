module Components
  module Databasium
    class Records::Table < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::HiddenFieldTag
      include Phlex::Rails::Helpers::CheckBoxTag
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(
        records:,
        model:,
        turbo_frame:,
        pagy: nil,
        feedback: nil,
        render_as_cards: false
      )
        @records = records
        @model = model
        @turbo_frame = turbo_frame
        @pagy = pagy
        @feedback = feedback
        @render_as_cards = render_as_cards
      end

      def view_template
        turbo_frame_tag(@turbo_frame, class: "flex min-h-0 min-w-0 flex-1 flex-col relative") do
          form_with(
            url: databasium.bulk_destroy_records_path,
            data: {
              turbo_method: :destroy,
              action: "submit->table#resetDeleteButton"
            },
            method: :delete,
            scope: :table,
            id: "delete_records_form",
            class: "flex min-h-0 min-w-0 flex-1 flex-col"
          ) do |form|
            hidden_field_tag(:table, @model.name)
            div(class: "flex-1 min-h-0 min-w-0 max-h-fit overflow-auto") do
              if @render_as_cards
                render_card_body
              else
                table(class: "whitespace-nowrap bg-panel min-w-max w-full") do
                  render_table_head
                  render_table_body
                end
              end
            end
            render_pagy
          end
        end
      end

      private

      def render_table_head
        thead do
          tr(class: "bg-accent shadow-accent") do
            if @turbo_frame == "records_list"
              th(class: table_head_classes) do
                button(
                  type: "button",
                  data: {
                    action: "click->table#toggleAllRecords",
                    table_target: "toggleAllRecordsButton"
                  },
                  class: "px-4 py-1 rounded-xl text-base me-2 hover:text-hover"
                ) { heroicon("check-circle", variant: :solid, options: { class: "w-6 h-6" }) }
              end
            end
            @model&.columns&.each do |column|
              th(class: table_head_classes) do
                plain column.name
              end
            end
          end
        end
      end

      def render_card_body
        div(id: "records_body", class: "grid gap-4 w-full p-4 justify-center w-full") do
          if @records&.any?
            @records.each do |record|
              render Components::Databasium::Records::Table::Row.new(
                       record: record,
                       turbo_frame: @turbo_frame,
                       render_as_cards: @render_as_cards
                     )
            end
          else
            render Components::Databasium::Global::Suggestion.new(
                     suggestions: [ @feedback || "No records found for #{@model&.name} table." ]
                   )
          end
        end
      end

      def render_table_body
        tbody(id: "records_body") do
          if @records&.any?
            @records.each do |record|
              render Components::Databasium::Records::Table::Row.new(
                       record: record,
                       turbo_frame: @turbo_frame,
                       render_as_cards: @render_as_cards
                     )
            end
          else
            render Components::Databasium::Global::Suggestion.new(
                     suggestions: [ @feedback || "No records found for #{@model&.name} table." ]
                   )
          end
        end
      end

      def render_pagy
        if @pagy && @records&.any?
          div(class: "m-4 flex justify-start") { raw @pagy.series_nav.html_safe }
        end
      end

      def table_head_classes
        "text-center w-55 max-w-55 py-2 border-1 border-border overflow-auto"
      end
    end
  end
end

# frozen_string_literal: true

module Views
  module Databasium
    class Records::Index < Views::Base
      include Phlex::Rails::Helpers::ContentFor
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::LinkTo

      def initialize(model:, columns_names_types:, table: nil, tables: nil, pagy_tables: nil)
        @columns_names_types = columns_names_types
        @model = model
        @table = table
        @tables = tables
        @pagy_tables = pagy_tables
      end

      def view_template
        content_for(:title) { "Records" }
        content_for(:sidebar) { render_sidebar }
        turbo_frame_tag "records",
                        class: "flex min-h-0 min-w-0 flex-1 flex-col",
                        src:
                          helpers.records_records_path(
                            table: @table,
                            frame_id: "records",
                            limit: 10
                          ) do
          "Loading"
        end
        div(class: "absolute right-0 flex flex-col min-h-0 items-end") do
          div(class: "bg-panel flex-1 min-h-0 overflow-y-auto rounded-bl-xl mb-2 min-h-[calc(100dvh-51px)] flex flex-col min-w-1/3 max-w-125", data: { table_target: "recordsPanel" }) do
            button(
              class: "w-fit text-accent hover:text-accent-dark border-1 border-accent p-1 rounded-xl m-2 ms-auto",
              data: { action: "click->table#closeRecordsPanel" }) do
                raw heroicon("x-mark", variant: :solid, options: { class: "w-6 h-6" })
              end
            div(class: "flex bg-background px-2 overflow-x-auto max-w-fill divide-x-1 divide-border gap-x-2", data: { table_target: "recordTabs" }) do
              template(data: { table_target: "recordTab" }) do
                button(type: "button", class: "flex items-center gap-2 px-2 cursor-pointer", data: { action: "click->table#openTab" }) do
                  div(data: { table_target: "recordTabTitle" }) { plain "Name" }
                  raw heroicon("x-mark", variant: :solid, options: { class: "w-3 h-3 me-auto hover:bg-panel" })
                end
              end
            end
            div(class: "", data: { table_target: "recordTabsContent" }) { plain "Double click on a record to update to open update form" }
            button(
            class: "w-fit text-accent hover:text-accent-dark border-1 border-accent p-1 rounded-xl m-2 bg-panel",
            data: { action: "click->table#openRecordsPanel" }) { heroicon("arrow-left", variant: :solid, options: { class: "w-6 h-6" }) }
          end
        end
      end

      private

      def render_sidebar
        div(class: "flex flex-col w-full") do
          render Components::Databasium::Forms::Search.new(
                   url: databasium.records_path,
                   turbo_frame: "results",
                   placeholder: "Search for a table"
                 )
          turbo_frame_tag("results") do
            @tables&.each do |table|
              div(class: "border-b-2 border-b-border py-2 px-3") do
                link_to "#{table}",
                        databasium.records_records_path(table: table, refresh: true),
                        data: {
                          turbo_stream: true
                        }
              end
            end
            if @tables
              div(class: "mt-4 flex justify-start") { raw @pagy_tables.series_nav.html_safe }
            end
          end
        end
      end

      def render_main
        turbo_frame_tag "records",
                        class: "",
                        src: helpers.records_records_path(table: @table, frame_id: "records") do
          "Loading"
        end
      end
    end
  end
end

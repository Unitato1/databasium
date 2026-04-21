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
        div(class: "flex flex min-h-0 min-w-0 flex-1") do
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
        render Components::Databasium::Records::Table::RecordPanel.new
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

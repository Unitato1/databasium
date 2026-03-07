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
        div(class: "flex px-4 gap-4") do
          div(class: "") { render_sidebar }
          div(class: "w-full") { render_main }
        end
      end

      private

      def render_sidebar
        div(class: "flex flex-col w-full") do
          div(data: { controller: "search" }) do
            form_with url: helpers.records_path,
                      method: :get,
                      class: "flex gap-2",
                      data: {
                        turbo_frame: "results",
                        action: "input->search#update"
                      } do |form|
              raw form.search_field :search,
                                    class: "border-2 border-gray-300 rounded-md p-2",
                                    placeholder: "Search for a table"
            end
          end
          turbo_frame_tag("results") do
            @tables&.each do |table|
              div(class: "border-b-2 border-b-gray-300 py-2 px-3") do
                link_to "#{table}",
                        helpers.records_path(table: table),
                        data: {
                          turbo_frame: "main"
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
        turbo_frame_tag("main") do
          if @model
            render Components::Databasium::Navigation::IconPanel.new(
                     icons_with_text: [
                       { icon: "plus-circle", text: "add record" },
                       { icon: "funnel", text: "filter" }
                     ],
                     vertical: true
                   )
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
          end
          turbo_frame_tag "records",
                          class: "overflow-auto block",
                          src: helpers.records_records_path(table: @table, frame_id: "records") do
            "Loading"
          end
        end
      end
    end
  end
end

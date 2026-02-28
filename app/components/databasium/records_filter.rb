# frozen_string_literal: true

module Components
  module Databasium
    class RecordsFilter < Phlex::HTML
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::HiddenFieldTag

      def initialize(records:, model:, path:, turbo_frame:)
        @records = records
        @model = model
        @path = path
        @turbo_frame = turbo_frame
      end

      def view_template
        render_filter
      end

      private

      def render_filter
        form_with(
          url: helpers.records_records_path,
          method: :get,
          class: "border-1 border-gray-300 p-4 bg-gray-100 rounded-xl min-w-125 w-fit max-h-50 overflow-y-auto",
          data: {
              action: "change->search#update",
              filter_target: "form",
              turbo_frame: @turbo_frame }
        ) do |form|
          hidden_field_tag :table, @model.name
          hidden_field_tag :frame_id, @turbo_frame
          div(class: "flex items-center justify-between") do
            span(
              type: "button",
              data: { action: "click->filter#addFilter" },
              class: "ps-4 py-1 rounded underline w-fit") do
              "Add Filter"
            end
            form.submit "Run Filters", class: "bg-blue-500 text-white px-4 py-2 rounded-md"
          end
          raw helpers.heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8 hidden mr-2", data_filter_target: "removeIcon" }
        end
      end
      # /
    end
  end
end

# <% if @model %>
#   <%= tag.div id: "filter",
#     class: "hidden my-4",
#     data: {
#       controller: "filter",
#       filter_columns_value: @columns_names_types.to_json
#     } do %>
#     <%= form_with(url: records_path, method: :get,
#         class: "border-1 border-gray-300 p-4 bg-gray-100 rounded-xl min-w-125 w-fit max-h-50 overflow-y-auto",
#         data: {
#           action: "change->search#update",
#           filter_target: "form",
#           turbo_frame: "records"
#       },
#       ) do |form| %>
#       <%= hidden_field_tag :table, @model.name %>
#       <div class="flex items-center justify-between">
#         <span type="button"
#           data-action="click->filter#addFilter"
#           class="ps-4 py-1 rounded underline w-fit">
#           Add Filter
#         </span>
#         <%= form.submit "Run Filters", class: "bg-blue-500 text-white px-4 py-2 rounded-md" %>
#       </div>
#     <% end %>
#     <%= heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8 hidden mr-2", data_filter_target: "removeIcon" } %>
#   <% end %>
# <% end %>

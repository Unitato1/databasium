# frozen_string_literal: true

module Components
  module Databasium
    class Records < Phlex::HTML
      def initialize(records:, model:)
        @records = records
        @model = model
      end

      def view_template
        render_table
      end

      private

      def render_table
        if @model
          table(class: "table-fixed border-2 border-gray-300 whitespace-nowrap min-w-max") do
            render_table_head
            render_table_body
          end
        else
          p(class: "text-center text-2xl text-gray-500") { "Select a table to view its records" }
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
        tbody(id: "records_list") do
          if @records&.any?
            @records.each do |record|
              tr(class: "border-2 border-gray-300 hover:bg-gray-100") do
                record.attributes.each do |_, value|
                  td(class: "text-center w-55 max-w-55 py-2 border-2 border-gray-300 overflow-auto") do
                    plain format_cell_value(value)
                  end
                end
              end
            end
          else
            if @error
              div(class: "border-2 border-gray-500 text-center p-4 rounded-xl bg-red-100") do
                p(class: "text-red-500 text-2xl") do
                  @error
                end
              end
            else
              p("No records found")
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
      # /
    end
  end
end

# <table class="table-fixed border-2 border-gray-300 whitespace-nowrap min-w-max">
# <thead>
#   <tr class="border-2 border-gray-300">
#     <% @model&.columns&.each do |column| %>
#       <th class="text-center w-55 max-w-55 py-2 border-2 border-gray-300 overflow-auto"><%= column.name %></th>
#     <% end %>
#   </tr>
# </thead>
# <tbody id="records_list">
#   <% if @records&.any? %>
#     <% @records.each do |record| %>
#       <tr class="border-2 border-gray-300 hover:bg-gray-100">
#         <% record.attributes.each do |_, value| %>
#           <td class="text-center w-55 max-w-55 py-2 border-2 border-gray-300 overflow-auto"><%= value %></td>
#         <% end %>
#       </tr>
#     <% end %>
#   <% else %>
#     <% if @error %>
#       <div class="border-2 border-gray-500 text-center p-4 rounded-xl bg-red-100">
#         <p class="text-red-500 text-2xl"><%= @error %></p>
#       </div>
#     <% else %>
#       <p>No records found</p>
#     <% end %>
#   <% end %>
# <% else %>
#   <p>Select a table to view its records</p>
# <% end %>
# </tbody>
# </table>

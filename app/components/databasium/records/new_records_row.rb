# <tr class="border-2 border-gray-300 hover:bg-gray-100">
#   <% record.attributes.each do |_, value| %>
#     <td class="text-center w-55 max-w-55 py-2 border-2 border-gray-300 overflow-auto"><%= value %></td>
#   <% end %>
# </tr>
# frozen_string_literal: true

module Components
  module Databasium
    class Records::NewRecordsRow < Components::Base
      def initialize(record:)
        @record = record
      end

      def view_template
        tr(class: "border-border border-1") do
          @record.attributes.each do |_, value|
            td(class: "text-center w-55 py-2 border-border border-1 overflow-auto") do
              value
            end
          end
        end
      end
    end
  end
end

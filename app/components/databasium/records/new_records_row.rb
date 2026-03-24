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
            td(class: "text-center w-55 py-2 border-border border-1 overflow-auto") { value }
          end
        end
      end
    end
  end
end

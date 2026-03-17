# frozen_string_literal: true

module Components
  module Databasium
    class TypeSelect < Components::Base
      def initialize(name: nil)
        @name = name
      end

      def view_template
        select(name: @name, class: "border-2 rounded-xl px-2 py-1 border-border h-full bg-background focus:outline-none") do
          option(value: "text") { "Text" }
          option(value: "string") { "String" }
          option(value: "integer") { "Integer" }
          option(value: "float") { "Float" }
          option(value: "decimal") { "Decimal" }
          option(value: "time") { "Time" }
          option(value: "date") { "Date" }
          option(value: "datetime") { "Datetime" }
          option(value: "timestamp") { "Timestamp" }
          option(value: "binary") { "Binary" }
          option(value: "boolean") { "Boolean" }
          option(value: "references") { "Reference" }
        end
      end
    end
  end
end

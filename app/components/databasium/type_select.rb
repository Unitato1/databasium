# frozen_string_literal: true

module Components
  module Databasium
    class TypeSelect < Components::Base
      def initialize(name: nil, value: nil)
        @name = name
        @value = value
      end

      def view_template
        select(
          name: @name,
          class:
            "border-2 rounded-xl px-2 py-1 border-border h-full bg-background focus:outline-none",
        ) do
          [
            [ "text", "Text" ],
            [ "string", "String" ],
            [ "integer", "Integer" ],
            [ "float", "Float" ],
            [ "decimal", "Decimal" ],
            [ "time", "Time" ],
            [ "date", "Date" ],
            [ "datetime", "Datetime" ],
            [ "timestamp", "Timestamp" ],
            [ "binary", "Binary" ],
            [ "boolean", "Boolean" ],
            [ "references", "Reference" ]
          ].each do |value, label|
            option(value: value, selected: @value == value) { label }
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class Models::Templates::Validation < Models::Templates::Base
      def initialize(validation: nil, name: nil)
        @validation = validation
        @name = name
      end

      def view_template
        selected_validation = @validation&.fetch(:type, nil)
        div(class: "flex gap-2 mt-2") do
          input(
            type: "text",
            name: "model[attributes][][validations][][name]",
            value: @name,
            data: {
              attribute_target: "nameValidationInput"
            },
            class: "hidden"
          )
          select(
            name: "model[attributes][][validations][][type]",
            class:
              "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background focus:outline-none"
          ) do
            [
              [ "presence", "Presence" ],
              [ "uniqueness", "Uniqueness" ],
              [ "format", "Format" ],
              [ "inclusion", "Inclusion" ],
              [ "exclusion", "Exclusion" ],
              [ "numericality", "Numericality" ],
              [ "length", "Length" ],
              [ "comparison", "Comparison" ],
              [ "confirmation", "Confirmation" ],
              [ "acceptance", "Acceptance" ]
            ].each do |value, label|
              option(value: value, selected: selected_validation == value) { label }
            end
          end
          input(
            type: "text",
            name: "model[attributes][][validations][][value]",
            value: @validation&.fetch(:value, nil),
            placeholder: "Value (e.g. true)",
            class:
              "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background focus:outline-none"
          )
        end
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class Models::Templates::Validation < Models::Templates::Base
      def initialize
      end

      def view_template
        template(data: { model_target: "validation" }) do
          div(class: "flex gap-2 mt-2") do
            input(
              type: "text",
              name: "model[attributes][][validations][][name]",
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
              option(value: "presence") { "Presence" }
              option(value: "uniqueness") { "Uniqueness" }
              option(value: "format") { "Format" }
              option(value: "inclusion") { "Inclusion" }
              option(value: "exclusion") { "Exclusion" }
              option(value: "numericality") { "Numericality" }
              option(value: "length") { "Length" }
              option(value: "comparison") { "Comparison" }
              option(value: "confirmation") { "Confirmation" }
              option(value: "acceptance") { "Acceptance" }
              option(value: "has_one") { "Has One" }
            end
            input(
              type: "text",
              name: "model[attributes][][validations][][value]",
              placeholder: "Value (e.g. true)",
              class:
                "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background focus:outline-none"
            )
          end
        end
      end
    end
  end
end

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
        div(class: "flex gap-2 px-2") do
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
              %w[presence Presence],
              %w[uniqueness Uniqueness],
              %w[format Format],
              %w[inclusion Inclusion],
              %w[exclusion Exclusion],
              %w[numericality Numericality],
              %w[length Length],
              %w[comparison Comparison],
              %w[confirmation Confirmation],
              %w[acceptance Acceptance]
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
          button(
            type: "button",
            class: "text-red-500",
            data: {
              action: "click->attribute#removeValidation"
            }
          ) { heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8" } }
        end
      end
    end
  end
end

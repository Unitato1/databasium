# frozen_string_literal: true

module Components
  module Databasium
    class Models::Templates::Validation < Models::Templates::Base
      TYPES = {
        presence: "Presence",
        uniqueness: "Uniqueness",
        format: "Format",
        inclusion: "Inclusion",
        exclusion: "Exclusion",
        numericality: "Numericality",
        length: "Length",
        comparison: "Comparison",
        acceptance: "Acceptance",
        absence: "Absence",
        confirmation: "Confirmation"
      }.freeze

      def initialize(validation: nil, name: nil)
        @validation = validation
        @name = name
        @selected_validation = @validation&.fetch(:type, nil)
        @validation_value = @validation&.fetch(:value, nil)
      end

      def view_template
        div(class: "flex gap-2 px-2") do
          render_validation_name_input
          div(class: "relative") do
            render_validation_type_select(selected_validation: @selected_validation)
            div(class: "absolute -top-1.5 -right-[0.5rem]") do
              heroicon "information-circle", variant: :solid, options: { class: "w-5 h-5" }
            end
          end
          render_acceptance_suggestions
          render_absence_suggestions
          render_confirmation_suggestions
          render_validation_value_input
          render_number_value_suggestions
          render_string_value_suggestions
          render_x_button(action: "click->attribute#removeValidation")
        end
      end

      private

      def render_validation_value_input
        input(
          type: "search",
          list: "acceptance-options",
          name: "model[attributes][][validations][][value]",
          class: "border-1 p-1 border-border w-full bg-background focus:outline-none",
            placeholder: "Value (e.g. true)",
          data: {
            validation_target: "valueInput"
          }
        )
      end

      def render_validation_type_select(selected_validation: nil)
        select(
          name: "model[attributes][][validations][][type]",
          class:
            "border-2 rounded-xl p-1 border-border w-fill bg-background focus:outline-none",
            data: { action: "change->validation#updateType" }
          ) do
          TYPES.each do |value, label|
            option(value: value, selected: selected_validation == value) { label }
          end
        end
      end
      # Validations
      # absence
      # acceptance
      # confirmation
      # comparison
      # format
      # inclusion and exclusion
      # length
      # numericality
      # presence
      # uniqueness
      # validates_associated
      # validates_each
      # validates_with
      # Validation Options
      # :allow_nil
      # :allow_blank
      # :message
      # :on

      def render_validation_name_input
        input(
          type: "text",
          name: "model[attributes][][validations][][name]",
          value: @name,
          data: {
            attribute_target: "nameValidationInput"
          },
          class: "hidden"
        )
      end

      def render_absence_suggestions
        datalist(id: "absence-options") do
          render_base_boolean_values
        end
      end

      def render_acceptance_suggestions
        datalist(id: "acceptance-options") do
          render_base_boolean_values
          option(value: 'acceptance: { message: "must be agreed to" }') { "With message" }
          option(value: 'acceptance: { accept: "yes" }') { "Accept" }
        end
      end

      def render_confirmation_suggestions
        datalist(id: "confirmation-options") do
          render_base_boolean_values
        end
      end

      def render_base_boolean_values
        option(value: "true") { "If you woud like to true" }
        option(value: "false") { "False" }
      end

      def render_number_value_suggestions
        datalist(id: "numericality-options") do
          option(value: "true") { "If you woud like to true" }
          option(value: "false") { "False" }
        end
      end

      def render_string_value_suggestions
        datalist(id: "string-options") do
          option(value: "true") { "If you woud like to true" }
          option(value: "false") { "False" }
        end
      end

      def render_button_suggestion(value: nil, type: nil)
        button(type: "button", class: "text-text", data: { validation_target: "#{value}#{type&.upcase}" }) { value }
      end
    end
  end
end

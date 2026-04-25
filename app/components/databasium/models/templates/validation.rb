# frozen_string_literal: true

module Components
  module Databasium
    class Models::Templates::Validation < Models::Templates::Base
      TYPES = {
        presence: "Presence",
        uniqueness: "Uniqueness",
        inclusion: "Inclusion",
        exclusion: "Exclusion",
        validates_associated: "Validates Associated",
        numericality: "Numericality",
        length: "Length",
        acceptance: "Acceptance",
        absence: "Absence",
        confirmation: "Confirmation",
        comparison: "Comparison",
        format: "Format"
      }.freeze

      def initialize(validation: nil, name: nil)
        @validation = validation
        @name = name
        @selected_validation = @validation&.fetch(:type, nil)
        @validation_value = @validation&.fetch(:value, nil)
      end

      def view_template
        div(class: "p-2", data: { controller: "validation" }) do
          div(class: "flex gap-2") do
            render_validation_name_input
            div(class: "relative") do
              render_validation_type_select(selected_validation: @selected_validation)
              div(class: "absolute -top-1.5 -right-[0.5rem]", data: { action: "mouseenter->validation#showBasicInfo mouseleave->validation#hideBasicInfo" }) do
                heroicon "information-circle", variant: :solid, options: { class: "w-5 h-5" }
                render_basic_info
              end
            end
            render_acceptance_suggestions
            render_length_suggestions
            render_uniqueness_suggestions
            render_absence_suggestions
            render_confirmation_suggestions
            render_comparison_suggestions
            render_format_suggestions
            render_inclusion_suggestions
            render_exclusion_suggestions
            render_numericality_suggestions
            render_validates_associated_suggestions
            render_presence_suggestions
            render_validation_value_input
            render_x_button(action: "click->validation#remove")
          end
        end
      end

      private

      def render_basic_info
        div(data: { validation_target: "basicInfo" }, class: "hidden absolute z-20 w-64 p-4 mt-2 text-sm text-text bg-background border border-border rounded-xl shadow-xl bottom-full left-1/2 -translate-x-1/2") do
          div(class: "relative") do
            p(class: "font-semibold") { "Basic use case" }
            p(class: "text-text", data: { validation_target: "basicInfoText" }) { "" }
            div(class: "absolute -bottom-5.5 left-1/2 -translate-x-1/2 w-3 h-3 bg-background border-b border-r border-border rotate-45")
          end
        end
      end

      def render_validation_value_input
        div(class: "flex gap-2 px-2 mt-1 relative w-full") do
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
          div(class: "absolute -top-4 right-0 flex gap-1") do
            render_add_additional_options_button(action: "allowNil", text: "Allow nil")
            render_add_additional_options_button(action: "allowBlank", text: "Allow blank")
            render_add_additional_options_button(action: "onAction", text: "On Action")
          end
        end
      end

      def render_validation_type_select(selected_validation: nil)
        select(
          name: "model[attributes][][validations][][type]",
          class:
            "border-2 rounded-xl p-1 border-border w-fill bg-background focus:outline-none",
            data: { action: "change->validation#updateType" }
          ) do
          TYPES.each do |value, label|
            option(value: value.to_s, selected: selected_validation == value) { label }
          end
        end
      end

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
          option(value: '{ message: "must be agreed to" }') { "With message" }
          option(value: '{ accept: "yes" }') { "Accept" }
        end
      end

      def render_confirmation_suggestions
        datalist(id: "confirmation-options") do
          render_base_boolean_values
          option(value: "{ case_sensitive: false }") { "Case insensitive" }
        end
      end

      def render_comparison_suggestions
        datalist(id: "comparison-options") do
          option(value: "{ greater_than: 10 }") { "Greater than" }
          option(value: "{ greater_than_or_equal_to: 10 }") { "Greater than or equal to" }
          option(value: "{ equal_to: 10 }") { "Equal to" }
          option(value: "{ less_than: 10 }") { "Less than" }
          option(value: "{ less_than_or_equal_to: 10 }") { "Less than or equal to" }
          option(value: "{ other_than: 10 }") { "Other than" }
        end
      end

      def render_format_suggestions
        datalist(id: "format-options") do
          option(value: "{ with: /[A-Z]/ }") { "With" }
          option(value: "{ without: /[A-Z]/ }") { "Without" }
          option(value: "{ with: /[A-Z]/, message: 'must be uppercase' }") { "With and message" }
          option(value: "{ without: /[A-Z]/, message: 'must be lowercase' }") { "Without and message" }
        end
      end

      def render_inclusion_suggestions
        datalist(id: "inclusion-options") do
          option(value: "{ in: %w[a b c] }") { "Inclusion" }
          option(value: "{ in: ->(i) { i.method } }") { "Inclusion with proc" }
          option(value: "{ in: %w[a b c], message: 'must be a, b, or c' }") { "Inclusion and message" }
        end
      end

      def render_exclusion_suggestions
        datalist(id: "exclusion-options") do
          option(value: "{ in: %w[a b c] }") { "Exclusion" }
          option(value: "{ in: ->(i) { i.method } }") { "Exclusion with proc" }
          option(value: "{ in: %w[a b c], message: 'must be a, b, or c' }") { "Exclusion and message" }
        end
      end

      def render_length_suggestions
        datalist(id: "length-options") do
          option(value: "{ minimum: 2 }") { "Minimum" }
          option(value: "{ maximum: 10 }") { "Maximum" }
          option(value: "{ in: 2..10 }") { "Minimum and maximum" }
          option(value: "{ is: 10 }") { "Exact length" }
          option(value: "{ in: 2..10, too_short: 'is too short', too_long: 'is too long' }") { "Minimum and maximum with messages" }
          option(value: "{ in: 2..10, wrong_length: 'is the wrong length' }") { "Minimum and maximum with generic message" }
        end
      end

      def render_numericality_suggestions
        datalist(id: "numericality-options") do
          render_base_boolean_values
          option(value: "{ only_integer: true }") { "Only integer" }
          option(value: "{ greater_than: 10 }") { "Greater than" }
          option(value: "{ greater_than_or_equal_to: 10 }") { "Greater than or equal to" }
          option(value: "{ equal_to: 10 }") { "Equal to" }
          option(value: "{ less_than: 10 }") { "Less than" }
          option(value: "{ less_than_or_equal_to: 10 }") { "Less than or equal to" }
          option(value: "{ other_than: 10 }") { "Other than" }
          option(value: "{ in: 1..10 }") { "In range" }
          option(value: "{ odd: true }") { "Odd" }
          option(value: "{ even: true }") { "Even" }
        end
      end

      def render_presence_suggestions
        datalist(id: "presence-options") do
          render_base_boolean_values
        end
      end

      def render_uniqueness_suggestions
        datalist(id: "uniqueness-options") do
          render_base_boolean_values
          option(value: "{ scope: :column_name }") { "Scope" }
          option(value: "{ scope: :column_name, message: 'must be unique' }") { "Scope and with message" }
          option(value: "{ case_sensitive: false }") { "Case insensitive" }
          option(value: '{ conditions: -> { where(column: "value") } }') { "Conditions" }
        end
      end

      def render_validates_associated_suggestions
        datalist(id: "validates_associated-options") do
          option(value: ":model_name") { "Validates associated" }
        end
      end

      def render_base_boolean_values
        option(value: "true") { "If you woud like to true" }
        option(value: "false") { "False" }
      end

      def render_add_additional_options_button(action: nil, text: nil)
        button(type: "button", class: "text-text text-xs p-0.5 px-2 border-1 border-border rounded-xl bg-panel hover:bg-panel-hover cursor-pointer",
          data: { action: "validation##{action}" }) { text }
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

# frozen_string_literal: true

module Components
  module Databasium
    class Migrations::Form < Components::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(tables:, content:)
        @tables = tables
        @content = content
      end

      def view_template
        form_with(
          url: helpers.migrations_path,
          method: :post,
          id: "migration_form",
          data: {
            controller: "new-migration"
          },
          class:
            "flex flex-col gap-4 min-w-fit w-1/3 bg-panel border-1 border-border rounded-xl p-4"
        ) do |form|
          render_migration_action(form)
          render_table_name(form)
          render_columns(form)
          render_validations(form)
          render_table_datalist
          form.submit "Generate Preview",
                      class: "bg-blue-500 p-2 rounded-md w-fit",
                      name: "add_migration"
        end
      end

      private

      def render_validations(form)
        render_collapsable_with_button(
          form: form,
          name: "validations",
          data_targets: {
            new_migration_target: "validations"
          },
          button_text: "Add Validation",
          button_action: "click->new-migration#addValidation",
          name_params: {
            new_migration_target: "validation"
          },
          hidden: true
        ) do
          select(
            name: "validation[][column_name]",
            class: "p-2 border-1 border-border rounded-md w-fit bg-background",
            data: {
              new_migration_target: "validation_column_name"
            }
          ) { option(value: "") { "Select column" } }
          select(
            name: "validation[][type]",
            class: "p-2 border-1 border-border rounded-md w-fit bg-background",
            data: {
              new_migration_target: "validation_column_type"
            }
          ) do
            option(value: "uniqueness") { "Uniqueness" }
            option(value: "not_null") { "Not Null" }
          end
          render_remove_button(action: "click->new-migration#removeValidation")
        end
      end

      def render_columns(form)
        render_collapsable_with_button(
          form: form,
          name: "columns",
          data_targets: {
            new_migration_target: "columns"
          },
          button_text: "Add Column",
          button_action: "click->new-migration#addColumn",
          name_params: {
            new_migration_target: "column"
          },
          hidden: true
        ) do
          div(class: "flex flex-col gap-2 relative mt-2") do
            if @model
              form.select :column_name,
                          @model.columns.map(&:name),
                          include_blank: "Select a column name",
                          class: "p-2 border-1 border-border rounded-md w-fit bg-background"
            else
              form.label "Column Name", class: minimalistic_label_class
              form.text_field(
                :column_name,
                name: "columns[][column_name]",
                class: "p-1 border-1 rounded-xl border-border h-fit bg-background",
                data: {
                  action: "change->new-migration#updateColumnNames"
                }
              )
            end
          end
          div(class: "flex flex-col gap-2 h-full relative") do
            form.label "Column Name", class: minimalistic_label_class
            render Components::Databasium::TypeSelect.new(name: "columns[][column_type]")
          end
          render_remove_button(action: "click->new-migration#removeColumn")
        end
      end

      def render_table_name(form)
        render_collapsable_with_button(
          form: form,
          name: "table_name",
          data_targets: {
            new_migration_target: "table_name"
          },
        ) { form.text_field :table_name, class: "p-2 border-1 border-border w-fit bg-background rounded-md" }
      end

      def render_migration_action(form)
        render_collapsable_with_button(
          form: form,
          name: "migration_action",
          data_targets: {
            new_migration_target: "migration_action"
          }
        ) do
          div(class: "flex flex-col") do
            form.label :migration_action, "Action", class: "text-sm font-semibold"
            form.select :migration_action,
                        %w[create remove add],
                        {},
                        class: "p-2 border-1 border-border rounded-md w-fit bg-background",
                        data: {
                          action: "change->new-migration#set_action"
                        }
          end
          div(
            class: "flex flex-col",
            data: {
              new_migration_target: "add_model_container"
            }
          ) do
            form.label :add_model, "Add also model", class: "text-sm font-semibold"
            div(class: "h-11 flex items-center justify-center") { form.check_box :add_model,
                          checked: true,
                           class: "w-4 h-4",
                           data: {
                             new_migration_target: "add_model"
                           } }
          end

          div(class: "flex flex-col hidden", data: { new_migration_target: "table_name_from" }) do
            form.label :table_name_from, "Table to remove from", class: "text-sm font-semibold"
            render_tables_search_field(form, :table_name_from)
          end

          div(class: "flex flex-col hidden", data: { new_migration_target: "table_name_to" }) do
            form.label :table_name_to, "Table to add to", class: "text-sm font-semibold"
            render_tables_search_field(form, :table_name_to)
          end
        end
      end

      def render_tables_search_field(form, name)
        form.search_field name,
                          placeholder: "Search for a table",
                          list: "table_name_datalist",
                          class: "p-2 border-1 border-border rounded-md w-fit bg-background leading-5"
      end

      def render_table_datalist
        datalist(id: "table_name_datalist") do
          @tables.each do |table|
            option(value: table) { table }
          end
        end
      end

      def render_collapsable_with_button(
        form:,
        name:,
        data_targets:,
        button_text: nil,
        button_action: nil,
        name_params: {},
        hidden: false,
        &block
      )
        render_collapsable(
          form: form,
          name: name,
          data_targets: data_targets,
          class_name: "border-1 border-border rounded-xl py-1"
        ) do
          div(class: "flex gap-2 items-center px-2 mt-2 mb-2 #{hidden ? "hidden" : ""}", data: name_params) do
            yield if block_given?
          end
          if button_text.present? && button_action.present?
            button(
              type: "button",
              class: "text-accent ms-2 mt-1",
              data: {
                action: button_action
              }
            ) { heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } }
          end
        end
      end

      def render_remove_button(action: nil)
        button(type: "button", class: "text-red-500 h-fit self-center", data: { action: action }) do
          heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8" }
        end
      end
    end
  end
end

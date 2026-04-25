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
          form.submit "Generate Preview",
                      class: "bg-blue-500 p-2 rounded-md w-fit",
                      name: "add_migration"
        end
      end

      private

      def render_validations(form)
        render_collapsable(
          form: form,
          name: "validations",
          data_targets: {
            new_migration_target: "validations"
          }
        ) do
          div(class: "flex gap-2 items-center hidden", data: { new_migration_target: "validation" }) do
            select(
              name: "validation[][column_name]",
              class: "p-2 border-2 border-border rounded-md w-fit bg-background",
              data: {
                new_migration_target: "validation_column_name"
              }
            ) { option(value: "") { "Select column" } }
            select(
              name: "validation[][type]",
              class: "p-2 border-2 border-border rounded-md w-fit bg-background",
              data: {
                new_migration_target: "validation_column_type"
              }
            ) do
              option(value: "uniqueness") { "Uniqueness" }
              option(value: "not_null") { "Not Null" }
            end
            button(
              type: "button",
              class: "text-red-500 h-fit",
              data: {
                action: "click->new-migration#removeValidation"
              }
            ) { heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8" } }
          end
          button(
            type: "button",
            class: "text-accent",
            data: {
              action: "click->new-migration#addValidation"
            }
          ) { heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } }
        end
      end

      def render_columns(form)
        render_collapsable(
          form: form,
          name: "columns",
          data_targets: {
            new_migration_target: "columns"
          }
        ) do
          div(class: "flex gap-2 items-end hidden", data: { new_migration_target: "column" }) do
            div(class: "flex flex-col gap-2") do
              if @model
                form.select :column_name,
                            @model.columns.map(&:name),
                            include_blank: "Select a column name",
                            class: "p-2 border-2 border-border rounded-md w-fit bg-background"
              else
                form.label "Column Name", class: "text-sm font-semibold"
                form.text_field(
                  :column_name,
                  name: "columns[][column_name]",
                  class: "p-1 border-2 rounded-xl border-border h-fit bg-background",
                  data: {
                    action: "change->new-migration#updateColumnNames"
                  }
                )
              end
            end
            div(class: "flex flex-col gap-2 h-full") do
              form.label :column_type, "Column Type", class: "text-sm font-semibold"
              render Components::Databasium::TypeSelect.new(name: "columns[][column_type]")
            end
            button(
              type: "button",
              class: "text-red-500 h-fit",
              data: {
                action: "click->new-migration#removeColumn"
              }
            ) { heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8" } }
          end
          button(
            type: "button",
            class: "text-blue-500",
            data: {
              action: "click->new-migration#addColumn"
            }
          ) { heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } }
        end
      end

      def render_table_name(form)
        render_collapsable(
          form: form,
          name: "table_name",
          data_targets: {
            new_migration_target: "table_name"
          }
        ) { form.text_field :table_name, class: "p-2 border-2 border-border w-fit bg-background" }
      end

      def render_migration_action(form)
        render_collapsable(
          form: form,
          name: "migration_action",
          data_targets: {
            new_migration_target: "migration_action"
          }
        ) do
          form.select :migration_action,
                      %w[create remove add],
                      {},
                      class: "p-2 border-2 border-border rounded-md w-fit bg-background",
                      data: {
                        action: "change->new-migration#set_action"
                      }
          div(
            class: "flex items-center gap-2 py-2",
            data: {
              new_migration_target: "add_model_container"
            }
          ) do
            form.check_box :add_model,
                           checked: true,
                           class: "w-4 h-4",
                           data: {
                             new_migration_target: "add_model"
                           }
            form.label :add_model, "Add also model"
          end
          div(class: "flex flex-col hidden", data: { new_migration_target: "table_name_from" }) do
            form.label :table_name_from, "Table to remove from"
            form.select :table_name_from,
                        @tables,
                        { include_blank: "Select a table" },
                        class: "p-2 border-2 border-border rounded-md w-fit bg-background"
          end
          div(class: "flex flex-col hidden", data: { new_migration_target: "table_name_to" }) do
            form.label :table_name_to, "Table to add to"
            form.select :table_name_to,
                        @tables,
                        { include_blank: "Select a table" },
                        class: "p-2 border-2 border-border rounded-md w-fit bg-background"
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Views
  module Databasium
    class Migrations::New < Views::Base
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
          class: "flex p-4 gap-4",
          data: {
            controller: "new-migration"
          }
        ) do |form|
          div(
            class:
              "flex flex-col gap-4 min-w-fit w-1/3 bg-gray-100 rounded-xl p-4 border-2 border-gray-300"
          ) { render_form(form) }
          div(class: "flex-1 pe-4") do
            render Components::Databasium::Migrations::Preview.new(content: @content)
          end
        end
      end

      private

      def render_form(form)
        render Components::Databasium::Collapsable.new(name: "migration_action", form: form) do
          render_migration_action(form)
        end
        render Components::Databasium::Collapsable.new(
                 name: "table_name",
                 form: form,
                 data_targets: {
                   new_migration_target: "table_name"
                 }
               ) do
          render_table_name(form)
        end
        render Components::Databasium::Collapsable.new(
                 name: "columns",
                 form: form,
                 class_name: "flex flex-col border-b border-gray-300 pb-4 gap-2"
               ) do
          render_columns(form)
        end
        render Components::Databasium::Collapsable.new(
                 name: "validations",
                 form: form,
                 class_name: "flex flex-col border-b border-gray-300 pb-4 gap-2",
                 data_targets: {
                   new_migration_target: "validations"
                 }
               ) do
          render_validations(form)
        end
        form.submit "Generate Preview",
                    class: "bg-blue-500 text-white p-2 rounded-md w-fit",
                    name: "add_migration"
      end

      def render_migration_action(form)
        form.select :migration_action,
                    %w[create remove add],
                    {},
                    class: "p-2 border-2 border-gray-300 rounded-md w-fit",
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
                      class: "p-2 border-2 border-gray-300 rounded-md w-fit"
        end
        div(class: "flex flex-col hidden", data: { new_migration_target: "table_name_to" }) do
          form.label :table_name_to, "Table to add to"
          form.select :table_name_to,
                      @tables,
                      { include_blank: "Select a table" },
                      class: "p-2 border-2 border-gray-300 rounded-md w-fit"
        end
      end

      def render_table_name(form)
        form.text_field :table_name, class: "p-2 border-2 border-gray-300 w-fit"
      end

      def render_columns(form)
        div(class: "flex gap-2 items-end hidden", data: { new_migration_target: "column" }) do
          div(class: "flex flex-col gap-2") do
            if @model
              form.select :column_name,
                          @model.columns.map(&:name),
                          include_blank: "Select a column name",
                          class: "p-2 border-2 border-gray-300 rounded-md w-fit"
            else
              form.label "Column Name", class: "text-sm font-semibold"
              form.text_field(
                :column_name,
                name: "columns[][column_name]",
                class: "p-1 border-2 rounded-xl border-gray-300 h-fit",
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
            class: "text-red-500 border-2 border-red-500 rounded-xl h-fit",
            data: {
              action: "click->new-migration#removeColumn"
            }
          ) { helpers.heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8" } }
        end
        button(
          type: "button",
          class: "text-blue-500",
          data: {
            action: "click->new-migration#addColumn"
          }
        ) { helpers.heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } }
      end

      def render_validations(form)
        div(class: "flex gap-2 items-end hidden", data: { new_migration_target: "validation" }) do
          select(
            name: "validation[][column_name]",
            class: "p-2 border-2 border-gray-300 rounded-md w-fit",
            data: {
              new_migration_target: "validation_column_name"
            }
          ) { option(value: "") { "Select column" } }
          select(
            name: "validation[][type]",
            class: "p-2 border-2 border-gray-300 rounded-md w-fit",
            data: {
              new_migration_target: "validation_column_type"
            }
          ) do
            option(value: "uniqueness") { "Uniqueness" }
            option(value: "not_null") { "Not Null" }
          end
          button(
            type: "button",
            class: "text-red-500 border-2 border-red-500 rounded-xl h-fit",
            data: {
              action: "click->new-migration#removeValidation"
            }
          ) { helpers.heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8" } }
        end
        button(
          type: "button",
          class: "text-blue-500",
          data: {
            action: "click->new-migration#addValidation"
          }
        ) { helpers.heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } }
      end
    end
  end
end

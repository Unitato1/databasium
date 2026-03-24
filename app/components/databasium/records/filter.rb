# frozen_string_literal: true

module Components
  module Databasium
    class Records::Filter < Components::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::HiddenFieldTag
      include Phlex::Rails::Helpers::LinkTo
      def initialize(model:, turbo_frame:, columns_names_types:, hidden: true)
        @model = model
        @turbo_frame = turbo_frame
        @columns_names_types = columns_names_types
        @hidden = hidden
      end

      def view_template
        if @model
          div(
            class: class_names("hidden" => @hidden),
            id: "filter",
            data: {
              controller: "filter",
              filter_columns_value: @columns_names_types.to_json
            }
          ) { render_filter }
        end
      end

      private

      def render_filter
        form_with(
          url: databasium.records_records_path(table: @model.name, frame_id: @turbo_frame),
          method: :get,
          class: "max-h-100 overflow-y-auto border-b-1 rounded-xl border-border p-2 flex flex-col gap-2",
          data: {
            action: "change->search#update",
            filter_target: "form",
            turbo_frame: @turbo_frame
          }
        ) do |form|
          hidden_field_tag :table, @model.name
          hidden_field_tag :frame_id, @turbo_frame
          div(class: "w-full flex gap-4 items-center col-span-2") do
            button(
              data: {
                action: "click->filter#addFilter"
              },
              class: "ps-4 py-1 rounded underline w-fit"
            ) { "Add Filter" }
            div(class: "flex items-center gap-5") do
              form.submit("Run Filters", class: "bg-accent px-4 py-2 rounded-md", data: { turbo_stream: true })
            end
          end
        heroicon "x-mark",
                       variant: :solid,
                       options: {
                         class: "w-8 h-8 hidden mr-2",
                         data_filter_target: "removeIcon"
                       }
        end
      end
    end
  end
end

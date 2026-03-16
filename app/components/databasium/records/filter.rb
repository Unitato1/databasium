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
            class: class_names("", "" => @hidden),
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
          url: helpers.records_records_path,
          method: :get,
          class:
            "max-h-50 overflow-y-auto border-b-2 border-border p-2 flex flex-wrap",
          data: {
            action: "change->search#update",
            filter_target: "form",
            turbo_frame: @turbo_frame
          }
        ) do |form|
          hidden_field_tag :table, @model.name
          hidden_field_tag :frame_id, @turbo_frame
          div(class: "flex items-center gap-5") do
            span(
              data: {
                action: "click->filter#addFilter"
              },
              class: "ps-4 py-1 rounded underline w-fit"
            ) { "Add Filter" }
            form.submit "Run Filters", class: "bg-blue-500 px-4 py-2 rounded-md"
          end
          raw helpers.heroicon "x-mark",
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

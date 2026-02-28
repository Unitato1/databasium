# frozen_string_literal: true

module Components
  module Databasium
    class ModelForm < Phlex::HTML
      include Phlex::Rails::Helpers::HiddenFieldTag
      include Phlex::Rails::Helpers::ContentTag
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::TurboFrameTag

      TYPES = %w[string text integer float double decimal boolean date datetime timestamp time binary].freeze
      SKIPPED_COLUMNS = %w[created_at updated_at id].freeze

      def initialize(columns_names_types:, model:, path:)
        @columns_names_types = columns_names_types
        @path = path
        @model = model
      end

      def view_template
        form_with(
          url: @path,
          method: :post,
          scope: :record,
          class: "border-1 border-gray-300 p-4 bg-gray-100 rounded-xl min-w-125 w-fit overflow-y-auto mb-4 hidden",
          id: "add_record"
        ) { |form| form_content(form) }
      end

      private

      def form_content(form)
        render Components::Databasium::Collapsable.new(name: "Add New Record", form: form, data_targets: {}) do
          hidden_field_tag(:table, @model.name)
          div(class: "flex flex-col gap-2") do
            fields_content(form)
          end
        end
      end

      def fields_content(form)
        @columns_names_types.each do |column|
          next if column[:name].in?(SKIPPED_COLUMNS)


          div(class: "flex gap-2") do
            raw form.label(column[:name], class: "underline p-1 h-full w-1/3")
            if column[:foreign_key]
              foreign_key_content(form, column)
            else
              raw form.public_send(type_to_helper(column[:type]), column[:name], class: "border-2 rounded-xl p-1 border-gray-300 w-2/3")
            end
          end
        end
        raw form.submit("Add record", class: "bg-blue-500 text-white px-4 py-2 rounded-md")
      end

      def type_to_helper(type)
        unless type.in?(TYPES)
          raise ArgumentError, "Invalid type: #{type}. Known types are: #{TYPES.join(', ')}"
        end

        case type
        when "decimal", "float", "double", "integer"
          "number_field"
        when "text"
          "text_area"
        when "date"
          "date_field"
        when "datetime", "timestamp"
          "datetime_local_field"
        when "time"
          "time_field"
        when "boolean"
          "check_box"
        when "binary"
          "file_field"
        else
          "text_field"
        end
      end

      def foreign_key_content(form, column)
        frame_id = "foreign_records"

        p do
          column[:foreign_key] ? "This is a foreign key" : "This is not a foreign key"
        end
        link_to "Show table",
          helpers.foreign_records_records_path(table: column[:to_table]),
          class: "bg-blue-500 text-white px-4 py-2 rounded-md",
          data: { turbo_frame: frame_id }
        turbo_frame_tag(frame_id)
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class ModelForm < Phlex::HTML
      TYPES = %w[string text integer float double decimal boolean date datetime timestamp time binary].freeze
      SKIPPED_COLUMNS = %w[created_at updated_at id].freeze

      def initialize(columns_names_types:, model:, path:)
        @columns_names_types = columns_names_types
        @path = path
        @model = model
      end

      def view_template
        raw helpers.form_with(
          url: @path,
          method: :post,
          scope: :record,
          class: "border-1 border-gray-300 p-4 bg-gray-100 rounded-xl min-w-125 w-fit overflow-y-auto mb-4 hidden",
          data: { turbo_frame: "records" },
          id: "add_record"
        ) { |form| form_content(form) }
      end

      private

      def form_content(form)
        helpers.render Components::Databasium::Collapsable.new(name: "Add New Record", form: form, data_targets: {}) do
          helpers.safe_join([
            helpers.hidden_field_tag(:table, @model.name),
            helpers.content_tag(:div, fields_content(form), class: "flex flex-col gap-2")
          ])
        end
      end

      def fields_content(form)
        fields = @columns_names_types.filter_map do |column|
          next if column[:name].in?(SKIPPED_COLUMNS)

          helpers.content_tag(:div, class: "flex gap-2") do
            helpers.safe_join([
              form.label(column[:name], class: "underline p-1 h-full w-1/3"),
              form.public_send(type_to_helper(column[:type]), column[:name], class: "border-2 rounded-xl p-1 border-gray-300 w-2/3")
            ])
          end
        end

        fields << form.submit("Add record", class: "bg-blue-500 text-white px-4 py-2 rounded-md")
        helpers.safe_join(fields)
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
    end
  end
end

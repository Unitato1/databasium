# frozen_string_literal: true

module Databasium
  class ModelFormColumnComponent < ViewComponent::Base
    TYPES = %w[string text integer float decimal boolean date datetime time binary].freeze

    def initialize(name:, type:, form:)
      unless type.in?(TYPES)
        raise ArgumentError, "Invalid type: #{type}. Known types are: #{TYPES.join(', ')}"
      end
      @name = name
      @type = type
      @form = form
    end

    def type_to_helper
      case @type

      when "decimal", "float", "double"
        "number_field"

      when "integer"
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

      when "date"
        "date_field"

      when "binary"
        "file_field"

      else
        "text_field"
      end
    end
  end
end

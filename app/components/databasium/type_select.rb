# frozen_string_literal: true

module Components
  module Databasium
    class TypeSelect < Components::Base
      def initialize(name: nil, value: nil)
        @name = name
        @value = value
      end

      def view_template
        select(
          name: @name,
          class:
            "border-2 rounded-xl px-2 py-1 border-border h-full bg-background focus:outline-none"
        ) do
          [
            %w[text Text],
            %w[string String],
            %w[integer Integer],
            %w[float Float],
            %w[decimal Decimal],
            %w[time Time],
            %w[date Date],
            %w[datetime Datetime],
            %w[timestamp Timestamp],
            %w[binary Binary],
            %w[boolean Boolean],
            %w[references Reference]
          ].each { |value, label| option(value: value, selected: @value.to_s == value.to_s) { label } }
        end
      end
    end
  end
end

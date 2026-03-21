# frozen_string_literal: true

module Views
  module Databasium
    class Models::GetModel < Views::Base
      def initialize(model:)
        @model = model
      end

      def view_template
        render Components::Databasium::Models::Data.new(model: @model)
      end
    end
  end
end

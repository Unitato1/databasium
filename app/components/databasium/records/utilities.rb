module Components
  module Databasium
    class Records::Utilities < Components::Base
      def initialize(model:, columns_names_types:)
        @model = model
        @columns_names_types = columns_names_types
      end

      def view_template
        div(id: "records_utilities") do
          render Components::Databasium::Records::Filter.new(
            model: @model,
            turbo_frame: "records",
            columns_names_types: @columns_names_types,
            hidden: true
          )
          render Components::Databasium::Forms::Model.new(
            columns_names_types: @columns_names_types,
            model: @model
          )
        end
      end
    end
  end
end

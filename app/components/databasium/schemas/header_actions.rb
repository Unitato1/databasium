# frozen_string_literal: true

module Components
  module Databasium
    class Schemas::HeaderActions < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::HiddenFieldTag
      attr_reader :model, :layers

      def initialize(model:, layers:)
        @model = model
        @layers = layers
      end

      def view_template
        div(id: "header_actions", class: "flex max-w-full gap-2 overflow-x-auto") do
          unless model
            render Components::Databasium::Navigation::IconPanel.new(
                     icons_with_text: [
                       {
                         icon: "arrow-path-rounded-square",
                         text: "Sync Schema",
                         method: :put,
                         path: databasium.sync_schema_schemas_path
                       }
                     ]
                   )
          end
          if model
            render Components::Databasium::Navigation::IconPanel.new(
                     icons_with_text: [
                       {
                         icon: "arrow-path-rounded-square",
                         text: "Sync Schema",
                         method: :put,
                         path: databasium.sync_schema_schemas_path
                       },
                       {
                         icon: "table-cells",
                         text: "Model Schema",
                         method: :get,
                         turbo_frame: "records",
                         path: model_layers_path(model, 0),
                         active: layers == 0
                       },
                       {
                         icon: "share",
                         text: "Model Associations",
                         method: :get,
                         turbo_frame: "records",
                         path: model_layers_path(model, 1),
                         active: layers == 1
                       },
                       {
                         icon: "square-2-stack",
                         text: "Nested associations",
                         method: :get,
                         turbo_frame: "records",
                         path: model_layers_path(model, 2),
                         active: layers == 2
                       },
                       {
                         icon: "squares-2x2",
                         text: "All associations",
                         method: :get,
                         turbo_frame: "records",
                         path: model_layers_path(model, nil),
                         active: layers == nil
                       }
                     ]
                   )
          end
          if model
            form_with(
              method: :get,
              url: model_layers_path(model, layers),
              class: "border-l border-border pl-2 inline-flex gap-2 items-center"
            ) do |form|
              hidden_field_tag :model, model
              form.number_field :layers,
                                value: layers,
                                class:
                                  "w-10 border-1 border-border rounded-xl p-1 text-center text-sm"
              form.submit "Search for associations",
                          class: "text-sm bg-accent shadow-accent rounded-xl p-1.5 text-center"
            end
          end
        end
      end

      private

      def model_layers_path(model, layers)
        databasium.schemas_path(model: model, layers: layers)
      end
    end
  end
end

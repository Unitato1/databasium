module Components
  module Databasium
    class Models::Attributes < Components::Base
      def initialize(attributes: nil, models: nil)
        @attributes = attributes
        @models = models
      end

      def view_template
        render_collapsable(
          name: "Pre filled attributes and relations",
          form: nil,
          data_targets: {
            data: {
              attribute_target: "attributes"
            }
          },
          class_name: "bg-panel border-1 border-border rounded-xl p-2"
        ) do
          @attributes&.fetch(:columns_hash)&.each do |name, attribute|
            render Models::Templates::Attribute.new(name: name, params: attribute)
          end
          render_collapsable(
            name: "Relations",
            form: nil,
            data_targets: {
              data: {
                attribute_target: "relations"
              }
            },
            class_name: "bg-background border-1 border-border rounded-xl p-2"
          ) do
            @attributes&.fetch(:relations)&.each do |relation|
              render Models::Templates::Relation.new(relation: relation, models: @models)
            end
          end
        end
      end
    end
  end
end

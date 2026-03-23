module Components
  module Databasium
    class Models::Attributes < Components::Base
      def initialize(attributes: nil)
        @attributes = attributes
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
          @attributes&.fetch(:columns)&.each do |attribute|
            render Models::Templates::Attribute.new(attribute: attribute, validations: @attributes&.fetch(:validations, nil))
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
              render Models::Templates::Relation.new(relation: relation)
            end
          end
        end
      end
    end
  end
end

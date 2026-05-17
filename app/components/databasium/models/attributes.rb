module Components
  module Databasium
    class Models::Attributes < Components::Base
      def initialize(attributes: nil, models: nil)
        @attributes = attributes
        @models = models
      end

      def view_template
        @attributes
          .fetch(:unknown, [])
          .each do |line|
            input(type: "hidden", name: "model[unknown][]", value: line.fetch(:line, line["line"]))
          end
        render_collapsable(
          name: "Pre-filled attributes",
          form: nil,
          class_name: "bg-panel rounded-xl py-2"
        ) do
          div(
            class: "rounded-b-xl border border-border overflow-hidden divide-y divide-border mt-2"
          ) do
            @attributes
              &.fetch(:columns_hash)
              &.each do |name, attribute|
                render Models::Templates::Attribute.new(name: name, params: attribute)
              end
          end
        end
        render_collapsable(
          name: "Pre-filled relations",
          form: nil,
          data_targets: {
            controller: "relation"
          },
          class_name: "bg-panel mt-2 rounded-xl py-2"
        ) do
          div(class: "flex flex-col gap-2 py-2 px-3") do
            @attributes
              &.fetch(:relations)
              &.each do |relation|
                render Models::Templates::Relation.new(relation: relation, models: @models)
              end
          end
        end
      end
    end
  end
end

# </template>

module Components
  module Databasium
    class Models::Templates::Relation < Models::Templates::Base
      def initialize(relation: nil)
        @relation = relation
      end

      def view_template
        selected_relation = @relation&.fetch(:name, nil)

        div(class: "flex gap-2 mt-2") do
          select(
            name: "model[relations][][type]",
            class:
              "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background focus:outline-none"
          ) do
            [
              [ "belongs_to", "Belongs To" ],
              [ "has_many", "Has Many" ],
              [ "has_one", "Has One" ],
              [ "has_and_belongs_to_many", "Has And Belongs To Many" ]
            ].each do |value, label|
              option(value: value, selected: selected_relation == value) { label }
            end
          end
          input(
            type: "text",
            name: "model[relations][][table_name]",
            value: @relation&.fetch(:type, nil),
            placeholder: "Table name (e.g. user)",
            class:
              "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background focus:outline-none"
          )
        end
      end
    end
  end
end

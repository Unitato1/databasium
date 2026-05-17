# </template>

module Components
  module Databasium
    class Models::Templates::Relation < Models::Templates::Base
      def initialize(relation: nil, models: nil)
        @relation = relation
        @models = models
      end

      def view_template
        selected_relation = @relation&.fetch(:name, nil)
        selected_model = @relation&.fetch(:type, nil)&.classify
        div(class: "flex gap-2") do
          select(
            name: "model[relations][][type]",
            class: "border-2 rounded-xl p-1 border-border w-full bg-background focus:outline-none"
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
            type: "search",
            name: "model[relations][][table_name]",
            placeholder: "Search or select model",
            class: "border-2 rounded-xl p-1 border-border w-full bg-background focus:outline-none",
            value: selected_model,
            list: "models_datalist"
          ) { }
          button(
            type: "button",
            class: "text-red-500",
            data: {
              action: "click->relation#removeRelation"
            }
          ) { heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8" } }
        end
        render_models_datalist
      end

      private

      def render_models_datalist
        datalist(id: "models_datalist") do
          @models&.each { |model| option(value: model.classify) { model } }
        end
      end
    end
  end
end

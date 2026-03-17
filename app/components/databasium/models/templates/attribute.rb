module Components
  module Databasium
    class Models::Templates::Attribute < Models::Templates::Base
      def initialize
      end

      def view_template
        template(data: { model_target: "attribute" }) do
          div(data: { controller: "attribute" }) do
            render_attribute_fields
          end
        end
      end

      private

      def render_attribute_fields
        render_collapsable(name: "Attribute", form: nil, name_params: { data: { attribute_target: "name" } }) do
          div(class: "flex flex-col gap-2 mb-2 group bg-panel border-1 border-border rounded-xl p-2") do
            input(type: "text", name: "model[attributes][][name]", data: { action: "input->attribute#updateName", attribute_target: "nameInput" }, placeholder: "Attribute Name (e.g. email)", class: "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background")
            render Components::Databasium::TypeSelect.new(name: "model[attributes][][type]")
            render_validations
            render_relations
          end
        end
      end

      def render_validations
        render_collapsable(name: "Validation", form: nil, name_params: { data: { attribute_target: "validations" } }) do
          div(data: { model_target: "validationsContainer" }, class: "validationsContainer") do
            div(class: "flex items-center gap-2") do
              span(class: "font-semibold") { "Add new Validation" }
              button(data: { action: "click->model#add click->attribute#updateValidationName", model_target_param: "validation", model_container_param: "validationsContainer" }, type: "button", class: "text-blue-500") do
                helpers.heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" }
              end
            end
          end
        end
      end

      def render_relations
        render_collapsable(name: "Relation", form: nil, name_params: { data: { attribute_target: "relations" } }) do
          div(data: { model_target: "relationsContainer" }, class: "relationsContainer") do
            div(class: "flex items-center gap-2") do
              span(class: "font-semibold") { "Add new Relation" }
              button(data: { action: "click->model#add", model_target_param: "relation", model_container_param: "relationsContainer" }, type: "button", class: "text-blue-500") do
                helpers.heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" }
              end
            end
          end
        end
      end
    end
  end
end

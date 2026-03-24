module Components
  module Databasium
    class Models::Templates::Attribute < Models::Templates::Base
      def initialize(name: nil, params: nil)
        @name = name
        @params = params
      end

      def view_template
        div(data: { controller: "attribute" }) { render_attribute_fields }
      end

      private

      def render_attribute_fields
        render_collapsable(
          name: "Attribute",
          form: nil,
          data_targets: {
            data: {
              attribute_target: "name"
            }
          }
        ) do
          div(
            class: "flex flex-col gap-2 mb-2 group bg-panel border-1 border-border rounded-xl p-2"
          ) do
            input(
              type: "text",
              name: "model[attributes][][name]",
              value: @name,
              data: {
                action: "input->attribute#updateName",
                attribute_target: "nameInput"
              },
              placeholder: "Attribute Name (e.g. email)",
              class: "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background"
            )
            render Components::Databasium::TypeSelect.new(name: "model[attributes][][type]", value: @params&.fetch(:type, nil))
            attr_validations = @params&.fetch(:validations, nil)
            render_validations(validations: attr_validations)
          end
        end
      end

      def render_validations(validations: nil)
        render_collapsable(
          name: "Validation",
          form: nil,
          data_targets: {
            data: {
              attribute_target: "validations"
            }
          }
        ) do
          div(data: { model_target: "validationsContainer" }, class: "validationsContainer") do
            div(class: "flex items-center gap-2") do
              span(class: "font-semibold") { "Add new Validation" }
              button(
                data: {
                  action: "click->model#add click->attribute#updateValidationName",
                  model_target_param: "validation",
                  model_container_param: "validationsContainer"
                },
                type: "button",
                class: "text-blue-500"
              ) { heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } }
              validations&.each do |validation|
                render Models::Templates::Validation.new(validation: validation, name: @name)
              end
            end
          end
        end
      end
    end
  end
end

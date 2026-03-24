# frozen_string_literal: true

module Components
  module Databasium
    class Models::Form < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize(attributes: nil, model: nil)
        @attributes = attributes
        @model = model
      end

      def view_template
        form_with(
          url: databasium.models_path,
          method: :post,
          scope: :model,
          html: {
            id: "model_form"
          },
          data: {
            controller: "model"
          }
        ) do |form|
          render_model_name(form)
          render_form
          render_add_attribute(form)
          render_attributes_container
          render_add_relation(form)
          render_relations_container
          form.submit "Create preview for model",
                      class: "bg-accent shadow-accent rounded-xl p-1 px-4 py-2 mt-2"
        end
      end

      private

      def render_attributes_container
        div(data: { model_target: "attributesContainer" }) { }
      end

      def render_relations_container
        div(data: { model_target: "relationsContainer" }) { }
      end

      def render_add_relation(form)
        div(class: "flex items-center gap-2 bg-panel border-1 border-border rounded-xl p-2") do
          span(class: "font-semibold") { "Add new Relation" }
          button(
            data: {
              action: "click->model#add",
              model_target_param: "relation",
              model_container_param: "relationsContainer"
            },
            type: "button",
            class: "bg-accent shadow-accent rounded-md p-1"
          ) { heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } }
        end
      end

      def render_add_attribute(form)
        div(class: "flex items-center gap-2 bg-panel border-1 border-border rounded-xl p-2") do
          span(class: "font-semibold") { "Add new Attribute" }
          button(
            data: {
              action: "click->model#add",
              model_target_param: "attribute",
              model_container_param: "attributesContainer"
            },
            type: "button",
            class: "bg-accent shadow-accent rounded-md p-1"
          ) { heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } }
        end
      end

      def render_model_name(form)
        div(class: "flex flex-col mb-4") do
          form.label :model_name, "Model Name"
          form.text_field :model_name,
                          value: @model,
                          class: "border-1 rounded-xl p-1 border-border bg-panel text-sm w-fit mt-2"
        end
      end

      def render_form
        render Components::Databasium::Models::Attributes.new(attributes: @attributes)
        template(data: { model_target: "attribute" }) do
          render Components::Databasium::Models::Templates::Attribute.new
        end
        template(data: { model_target: "relation" }) do
          render Components::Databasium::Models::Templates::Relation.new
        end
        template(data: { model_target: "validation" }) do
          render Components::Databasium::Models::Templates::Validation.new
        end
      end
    end
  end
end

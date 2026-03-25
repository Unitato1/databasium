# frozen_string_literal: true

module Components
  module Databasium
    class Models::Form < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize(attributes: nil, model: nil, models: nil)
        @attributes = attributes
        @model = model
        @models = models
      end

      def view_template
        form_with(
          url: databasium.models_path,
          method: :post,
          scope: :model,
          html: {
            id: "model_form"
          }
        ) do |form|
          render_model_name(form)
          render_form
          render_attributes_container
          render_relations_container
          form.submit "Create preview for model",
                      class: "bg-accent shadow-accent rounded-xl p-1 p-2 mt-2 w-full text-center"
        end
      end

      private

      def render_attributes_container
        render_collapsable(
          name: @model.present? ? "New Attributes" : "Attributes",
          form: nil,
          class_name: "bg-panel rounded-xl py-2 mt-2"
        ) do
          div(
            class: "rounded-b-xl border border-border overflow-hidden divide-y divide-border mt-2", data: { model_target: "attributesContainer" }
          ) { }
        end
      end

      def render_relations_container
        render_collapsable(
          name: @model.present? ? "New Relations" : "Relations",
          form: nil,
          class_name: "bg-panel rounded-xl py-2 mt-2"
        ) do
          div(
            class: "flex flex-col gap-2 py-2 px-3", data: { model_target: "relationsContainer" }
          ) { }
        end
      end

      def render_model_name(form)
        div(class: "flex items-center mb-3 text-xl") do
          form.label :model_name, "Name:", class: "font-semibold pe-2"
          form.text_field :model_name,
                          value: @model,
                          class:
                            "border-1 w-full rounded-xl p-1 border-border bg-panel w-fit focus:outline-none"
        end
      end

      def render_form
        if @attributes.present?
          render Components::Databasium::Models::Attributes.new(
                   attributes: @attributes,
                   models: @models
                 )
        end
        template(data: { model_target: "attribute" }) do
          render Components::Databasium::Models::Templates::Attribute.new
        end
        template(data: { model_target: "relation" }) do
          render Components::Databasium::Models::Templates::Relation.new(models: @models)
        end
        template(data: { model_target: "validation" }) do
          render Components::Databasium::Models::Templates::Validation.new
        end
      end
    end
  end
end

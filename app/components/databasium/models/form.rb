# <%= form_with(url: models_path, method: :post, scope: :model, html: { id: "model_form" }, data: { controller: "model" }) do |form| %>
#   <%= render "databasium/models/components/attribute_template" %>
#   <%= render "databasium/models/components/validation_template" %>
#   <%= render "databasium/models/components/relation_template" %>
#   <div class="bg-gray-100 border-2 border-gray-300 p-4 rounded-2xl min-h-full flex-1 p-4">
#     <div class="flex flex-col mb-4">
#       <%= form.label :model_name, "Model Name" %>
#       <%= form.text_field :model_name, class: "border-2 rounded-xl p-1 border-gray-300 w-fit mt-2" %>
#     </div>
#     <div class="flex items-center gap-2">
#       <span class="font-semibold">Add new Attribute</span>
#       <button
#           data-action="click->model#add"
#         data-model-target-param="attribute"
#         data-model-container-param="attributesContainer"
#         type="button" class="text-blue-500">
#         <%= heroicon "plus-circle", variant: :outline, options: { class: "w-8 h-8" } %>
#       </button>
#     </div>
#     <div data-model-target="attributesContainer">
#     </div>
#     <%= form.submit "Create preview for model", class: "bg-blue-500 px-4 py-2 rounded-md mt-2" %>
#   </div>
# <% end %>
# frozen_string_literal: true

module Components
  module Databasium
    class Models::Form < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize
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
          render_form
          render_model_name(form)
          render_add_attribute(form)
          render_attributes_container
          form.submit "Create preview for model",
                      class: "bg-accent shadow-accent rounded-xl p-1 px-4 py-2 mt-2"
        end
      end

      private

      def render_attributes_container
        div(data: { model_target: "attributesContainer" }) {}
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
                          class: "border-1 rounded-xl p-1 border-border bg-panel text-sm w-fit mt-2"
        end
      end

      def render_form
        render Components::Databasium::Models::Templates::Attribute.new
        # render partial("databasium/models/components/attribute_template")
        render Components::Databasium::Models::Templates::Relation.new
        render Components::Databasium::Models::Templates::Validation.new
        # render partial("databasium/models/components/relation_template")
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class Models::HeaderActions < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::ButtonTo
      def initialize(model: nil)
        @model = model
      end

      def view_template
        div(id: "header_actions") do
          render Components::Databasium::Navigation::IconPanel.new(
            icons_with_text: [
              { icon: "plus-circle", text: "Add attribute", method: :frontend,           data_params: {
                action: "click->model#add",
                model_target_param: "attribute",
                model_container_param: "attributesContainer"
              } },
              { icon: "plus-circle", text: "Add relation", method: :frontend,           data_params: {
                action: "click->model#add",
                model_target_param: "relation",
                model_container_param: "relationsContainer"
              } },
              { icon: "document-plus", text: "New model", method: :get, path: databasium.new_model_path, turbo_frame: "main" }
              ]
          )
        end
      end
    end
  end
end

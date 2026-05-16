# frozen_string_literal: true

module Views
  module Databasium
    class Models::New < Views::Base
      include Phlex::Rails::Helpers::ContentFor
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(content:, model: nil, attributes: nil, models: nil, pagy: nil)
        @model = model
        @content = content
        @attributes = attributes
        @models = models
        @pagy = pagy
      end

      def view_template
        content_for(:title) { "New Model" }
        content_for(:sidebar) { render Components::Databasium::Models::Sidebar.new }
        content_for(:header_actions) do
          render Components::Databasium::Models::HeaderActions.new(model: @model)
        end
        div(class: "flex gap-4 p-4 overflow-y-hidden flex-1") do
          div(class: "w-1/2 overflow-y-auto") do
            render Components::Databasium::Models::Form.new(
                     attributes: @attributes,
                     model: @model,
                     models: @models
                   )
          end
          div(class: "flex-1 overflow-y-auto") do
            render Components::Databasium::Models::ModelPreview.new(content: @content)
          end
        end
      end
    end
  end
end

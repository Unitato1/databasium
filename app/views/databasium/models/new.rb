# frozen_string_literal: true

module Views
  module Databasium
    class Models::New < Views::Base
      include Phlex::Rails::Helpers::ContentFor

      def initialize(model:, content:, models:, pagy:)
        @model = model
        @content = content
        @models = models
        @pagy = pagy
      end

      def view_template
        content_for(:title) { "New Model" }
        content_for(:sidebar) { render Components::Databasium::Models::Sidebar.new(models: @models, pagy: @pagy) }
        div(class: "flex gap-4 p-4") do
          div(class: "w-1/4") do
            render Components::Databasium::Models::Form.new
          end
          div(class: "flex-1") do
            render Components::Databasium::Models::ModelPreview.new(content: @content)
          end
        end
      end
    end
  end
end

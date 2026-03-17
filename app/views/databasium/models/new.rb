# frozen_string_literal: true

module Views
  module Databasium
    class Models::New < Views::Base
      include Phlex::Rails::Helpers::ContentFor

      def initialize(model:, content:)
        @model = model
        @content = content
      end

      def view_template
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

# <div class="flex gap-4 p-4">
#   <div class="w-1/4">
#     <%= render "databasium/models/components/form" %>
#   </div>
#   <div class="flex-1">
#     <%= render "databasium/models/components/model_preview", content: @content %>
#   </div>
# </div>

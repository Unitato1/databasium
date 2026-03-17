# <div id="model_preview">
#   <div class="bg-panel border-1 border-border rounded-xl p-4 min-h-full flex-1">
#     <% if @content %>
#       <h1 class="text-xl font-semibold mb-3 border-b-2 border-border pb-3">Preview for Model</h1>
#       <pre><%= h @content %></pre>
#       <button
#         type="submit"
#         form="model_form"
#         name="commit"
#         value="Create model file"
#         class="bg-accent shadow-accent rounded-xl p-1 px-4 py-2 mt-2"
#       >
#         Create model file
#       </button>
#     <% else %>
#       <h1 class="text-xl font-semibold">Please fill out the form to see the preview</h1>
#     <% end %>
#   </div>
# </div>

module Components
  module Databasium
    class Models::ModelPreview < Components::Base
      def initialize(content:)
        @content = content
      end

      def view_template
        div(id: "model_preview") do
          div(class: "bg-panel border-1 border-border rounded-xl p-4 min-h-full flex-1") do
            if @content
              h1(class: "text-xl font-semibold mb-3 border-b-2 border-border pb-3") { "Preview for Model" }
              pre(class: "bg-panel border-1 border-border rounded-xl p-4") { @content }
              button(type: "submit", form: "model_form", name: "commit", value: "Create model file", class: "bg-accent shadow-accent rounded-xl p-1 px-4 py-2 mt-2") { "Create model file" }
            else
              h1(class: "text-xl font-semibold") { "Please fill out the form to see the preview" }
            end
          end
        end
      end
    end
  end
end

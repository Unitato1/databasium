module Components
  module Databasium
    class Migrations::Preview < Components::Base
      def initialize(content:)
        @content = content
      end

      def view_template
        div(id: "migration_preview") do
          div(class: "bg-gray-100 border-2 border-gray-300 p-4 rounded-2xl min-h-full") do
            if @content
              h1(class: "text-xl font-semibold mb-3") { "Preview Migration" }
              pre(class: "bg-gray-100 p-4 overflow-x-auto rounded-2xl") { @content }
              button(
                type: "submit",
                form: "migration_form",
                name: "add_migration",
                value: "Save",
                class: "bg-blue-500 p-2 rounded-md w-fit mt-4"
              ) { "Save" }
            else
              h1(class: "text-xl font-semibold") { "Please fill out the form to see the preview" }
            end
          end
        end
      end
    end
  end
end

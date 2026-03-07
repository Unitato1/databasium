module Components
  module Databasium
    class Migrations::Preview < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(content:)
        @content = content
      end

      def view_template
        turbo_frame_tag("migration_preview") do
          div(class: "bg-gray-100 border-2 border-gray-300 p-4 rounded-2xl min-h-full") do
            if @content
              h1(class: "text-xl font-semibold mb-3") do
                "Preview Migration"
              end
              pre(class: "bg-gray-100 p-4 overflow-x-auto rounded-2xl") do
                @content
              end
              button(type: "submit", form: "migration_form", name: "add_migration", value: "Save", class: "bg-blue-500 text-white p-2 rounded-md w-fit mt-4") do
                "Save"
              end
            else
              h1(class: "text-xl font-semibold") do
                "Please fill out the form to see the preview"
              end
            end
          end
        end
      end
    end
  end
end

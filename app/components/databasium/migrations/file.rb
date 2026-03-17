module Components
  module Databasium
    class Migrations::File < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::ContentFor

      def initialize(migration:, content:)
        @migration = migration
        @content = content
      end

      def view_template
        turbo_frame_tag "migration" do
          div(class: "px-4 w-full text-main-text mt-5", id: "migration") do
            render_content
            render_extra_info
          end
        end
      end

      private

      def render_content
        pre(
          class: "border-1 border-border bg-panel text-main-text p-4 overflow-x-auto rounded-2xl"
        ) { @content }
      end

      def render_extra_info
        div(class: "py-6") do
          h2(class: "text-lg font-semibold mb-2") { "Extra info: " }
          div(class: "flex gap-4") do
            ul(class: "list-disc list-inside w-fit") do
              li { "Timestamp: " }
              li { "Last time modified: " }
              li { "Name: " }
              li { "File path: " }
            end
            div do
              p(class: "font-bold") { @migration.version }
              p(class: "font-bold") do
                Time
                  .strptime(@migration.version.to_s, "%Y%m%d%H%M%S")
                  .localtime
                  .strftime("%Y-%m-%d at %H:%M:%S")
              end
              p(class: "font-bold") { @migration.name }
              p(class: "font-bold") { @migration.filename }
            end
          end
        end
      end
    end
  end
end

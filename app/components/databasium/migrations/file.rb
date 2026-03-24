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
          div(class: "mt-4 w-full scrollbar-thin overflow-y-auto", id: "migration") do
            h1(class: "text-2xl font-bold mb-4 text-ellipsis overflow-hidden break-all") { @migration.name }
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
        h2(class: "text-lg font-semibold my-2") { "Extra info: " }
        div(class: "grid grid-cols-[max-content_1fr] gap-4 w-fill break-all") do
          ul(class: "list-disc list-inside") do
            li { "Timestamp: " }
            li { "Last time modified: " }
            li { "Name: " }
            li { "File path: " }
          end
          div do
            p(class: "font-bold text-wrap") { @migration.version }
            p(class: "font-bold") {
              Time
                .strptime(@migration.version.to_s, "%Y%m%d%H%M%S")
                .localtime
                .strftime("%Y-%m-%d at %H:%M:%S")
            }
            p(class: "font-bold") { @migration.name }
            p(class: "font-bold") { @migration.filename }
          end
        end
      end
    end
  end
end

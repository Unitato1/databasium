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
        turbo_frame_tag "migration", class: "flex flex-col flex-1 p-4 w-full min-h-0 overflow-hidden" do
          h1(class: "text-2xl font-bold mb-2 text-ellipsis break-all") do
            @migration.name
          end
          render_content
          render_extra_info
        end
      end

      private

      def render_content
        pre(
          class: "min-h-0 flex-1 border-1 border-border bg-panel text-main-text p-4 overflow-auto rounded-2xl scrollbar-thin"
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

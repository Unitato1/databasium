module Components
  module Databasium
    class Migrations::File < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::ButtonTo

      def initialize(migration:, content:)
        @migration = migration
        @content = content
      end

      def view_template
        turbo_frame_tag "migration" do
          div(class: "px-4 w-full") do
            h1(class: "text-xl font-semibold") { "Migration File" }
            render_header
            render_content
            render_extra_info
          end
        end
      end

      private

      def render_header
        div(class: "p-2 sticky top-0") do
          link_to "Clear",
                  helpers.migrations_path,
                  data: {
                    turbo_frame: "migration",
                    turbo_action: "replace"
                  },
                  class: "text-blue-600 font-bold hover:underline text-xl"
          button_to "Rollback",
                    helpers.rollback_migration_migrations_path(version: @migration.version),
                    method: :post,
                    class: "text-blue-600 font-bold hover:underline text-xl",
                    form: {
                      data: {
                        turbo_stream: true
                      }
                    }

          button_to "Rollback till this migration",
                    helpers.rollback_migration_migrations_path(
                      version: @migration.version,
                      till_this_migration: true
                    ),
                    method: :post,
                    class: "text-blue-600 font-bold hover:underline text-xl",
                    form: {
                      data: {
                        turbo_stream: true
                      }
                    }

          button_to "Run Migration",
                    helpers.run_migration_migrations_path(version: @migration.version),
                    method: :post,
                    class: "text-blue-600 font-bold hover:underline text-xl",
                    form: {
                      data: {
                        turbo_stream: true
                      }
                    }
        end
      end

      def render_content
        pre(class: "bg-gray-100 p-4 overflow-x-auto rounded-2xl") { @content }
      end

      def render_extra_info
        div(class: "py-6") do
          h2(class: "text-lg font-semibold mb-2") { "Extra info: " }
          div(class: "flex gap-4") do
            ul(class: "list-disc list-inside w-fit") do
              li { "Timestamp: " }
              li { "Date: " }
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

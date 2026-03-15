# <% content_for(:title) { "Migrations" } %>

module Views
  module Databasium
    class Migrations::Index < Views::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::ContentFor

      def initialize(migrations:, pending_migrations:, migration_id:)
        @migrations = migrations
        @pending_migrations = pending_migrations
        @migration_id = migration_id
      end

      def view_template
        content_for(:title) { "Migrations" }
        content_for(:sidebar) { render_sidebar }
        div(class: "px-4 w-full flex flex-col lg:flex-row gap-4") { render_migration_frame }
      end

      private

      def render_sidebar
        div(class: "flex flex-col gap-2") do
          @migrations.each do |m|
            div(class: "flex items-center justify-between px-4") do
              link_to(
                "#{m.name}",
                helpers.migration_path(m.version),
                data: {
                  turbo_frame: "migration"
                },
                class: "text-main-text hover:text-hover flex items-center gap-2 py-1"
              )
              status = @pending_migrations.include?(m.version) ? "pending" : "applied"
              render Components::Databasium::Migrations::MigrationStatus.new(
                       status: status,
                       version: m.version
                     )
            end
          end
        end
        button_to(
          "Run Pending Migrations",
          helpers.run_pending_migrations_migrations_path,
          method: :post,
          class: "text-white bg-blue-600 rounded-xl p-2 mt-3"
        )
        form_with(
          url: helpers.rollback_migration_migrations_path,
          method: :post,
          class: "w-fit"
        ) do |form|
          form.number_field :rollback_steps,
                            placeholder: "Rollback steps",
                            class: "border-2 border-gray-300 rounded-xl p-2 w-full"
          form.submit "Rollback", class: "text-white bg-blue-600 rounded-xl p-2 mt-3 w-fit"
        end
      end

      def render_migration_frame
        if @migration_id.present?
          turbo_frame_tag "migration",
                          class: "flex-1",
                          src: helpers.migration_path(id: @migration_id) do
            "Select a migration to see the file"
          end
        else
          turbo_frame_tag "migration", class: "flex-1" do
            "Select a migration to see the file"
          end
        end
      end
    end
  end
end

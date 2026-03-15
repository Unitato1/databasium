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
            status = @pending_migrations.include?(m.version) ? "pending" : "applied"
              link_to(
                helpers.migration_path(m.version),
                data: {
                  turbo_stream: true
                },
                class: "text-main-text hover:text-hover hover:cursor-pointer flex items-center gap-2 p-1 border-b
                  border-border flex items-center justify-between"
              ) do
                p { "#{m.name}" }
                render Components::Databasium::Migrations::MigrationStatus.new(
                       status: status,
                       version: m.version)
            end
          end
        end
        div(class: "flex flex-col gap-2 mt-4") do
          form_with(
            url: helpers.rollback_migration_migrations_path,
            method: :post,
            class: "w-full flex gap-2 border-1 border-border rounded-md p-2"
          ) do |form|
            form.number_field :rollback_steps,
                              placeholder: "Rollback steps",
                              class: "p-2 w-full h-full focus:outline-none"
            form.submit "Rollback", class: "bg-secondary hover:bg-hover hover:cursor-pointer rounded-xl p-2 w-fit"
          end
          button_to(
            "Run Pending Migrations",
            helpers.run_pending_migrations_migrations_path,
            method: :post,
            class: "bg-secondary hover:bg-hover hover:cursor-pointer rounded-xl p-2"
          )
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

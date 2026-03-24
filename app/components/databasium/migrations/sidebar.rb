# frozen_string_literal: true

module Components
  module Databasium
    class Migrations::Sidebar < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(migrations:, pending_migrations:, pagy:)
        @migrations = migrations
        @pending_migrations = pending_migrations
        @pagy = pagy
      end

      def view_template
        render_migrations_list
        div(class: "flex flex-col gap-2 mt-4") do
          form_with(
            url: databasium.rollback_migration_migrations_path,
            method: :post,
            class: "w-full flex gap-2 border-1 border-border rounded-xl bg-background"
          ) do |form|
            form.number_field :rollback_steps,
                              placeholder: "Rollback steps",
                              class: "ps-4 w-full h-full focus:outline-none"
            form.submit "Rollback", class: "hover:cursor-pointer hover:text-hover text-accent p-2 w-fit"
          end
          button_to(
            "Run Pending Migrations",
            databasium.run_pending_migrations_migrations_path,
            method: :post,
            class: "bg-secondary hover:bg-hover hover:cursor-pointer rounded-xl py-2 px-4"
          )
        end
      end

      private

      def render_migrations_list
        div(class: "flex flex-col gap-2", data: { controller: "search" }) do
          render_search_for_migrations
          turbo_frame_tag("results") do
            render_migrations
          end
        end
        div(class: "mt-4 flex justify-start") { raw @pagy.series_nav.html_safe } if @pagy
      end

      def render_migrations
        @migrations.each do |m|
          status = @pending_migrations.include?(m.version) ? "pending" : "applied"
            link_to(
              databasium.migration_path(m.version),
              data: {
                turbo_stream: true
              },
              class: "text-main-text hover:text-hover hover:cursor-pointer flex items-center gap-2 p-1 border-b
                border-border flex items-center justify-between"
            ) do
              p(class: "max-w-fit overflow-x-auto me-2 scrollbar-thin p-1") { "#{m.name}" }
              render Migrations::MigrationStatus.new(
                    status: status,
                    version: m.version)
          end
        end
      end

      def render_search_for_migrations
        render Components::Databasium::Forms::Search.new(
          url: databasium.migrations_path,
          turbo_frame: "results",
          placeholder: "Search for a migration"
        )
      end
    end
  end
end

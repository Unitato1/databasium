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
            form.submit "Rollback",
                        class: "hover:cursor-pointer hover:text-hover text-accent p-2 w-fit"
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
          turbo_frame_tag("results", src: databasium.sidebar_migrations_path) do
            p(class: "mt-2 animate-pulse") { "Loading migrations..." }
          end
        end
      end

      def render_search_for_migrations
        render Components::Databasium::Forms::Search.new(
                 url: databasium.sidebar_migrations_path,
                 turbo_frame: "results",
                 placeholder: "Search for a migration"
               )
      end
    end
  end
end

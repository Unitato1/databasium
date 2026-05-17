# frozen_string_literal: true

module Components
  module Databasium
    class Migrations::HeaderActions < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::FormWith

      def initialize(migration:)
        @migration = migration
      end

      def view_template
        div(id: "header_actions", class: "max-w-full overflow-x-auto flex") do
          render Components::Databasium::Navigation::IconPanel.new(
                   icons_with_text: [
                     *(
                       if @migration
                         render_migration_actions
                       else
                         []
                       end
                     ),
                     {
                       icon: "document-plus",
                       text: "New Migration",
                       method: :get,
                       path: databasium.new_migration_path,
                       turbo_frame: "main"
                     },
                     {
                       icon: "forward",
                       text: "Run Pending Migrations",
                       method: :post,
                       path: databasium.run_pending_migrations_migrations_path,
                       turbo_frame: "main"
                     }
                   ]
                 )
          form_with(
            url: databasium.rollback_migration_migrations_path,
            method: :post,
            class: "w-fit flex gap-2 border-1 border-border rounded-xl bg-background text-sm mx-2"
          ) do |form|
            form.number_field :rollback_steps,
                              placeholder: "Rollback steps",
                              class: "ps-4 w-35 focus:outline-none"
            form.submit "Rollback",
                        class: "hover:cursor-pointer hover:text-hover text-accent w-fit pe-4"
          end
        end
      end

      private

      def render_migration_actions
        [
          {
            icon: "arrow-up",
            method: :post,
            text: "Run Migration",
            path: databasium.run_migration_migrations_path(version: @migration.version)
          },
          {
            icon: "arrow-uturn-left",
            method: :post,
            text: "Rollback",
            path: databasium.rollback_migration_migrations_path(version: @migration.version)
          },
          {
            icon: "backward",
            method: :post,
            text: "Rollback till this migration",
            path:
              databasium.rollback_migration_migrations_path(
                version: @migration.version,
                till_this_migration: true
              )
          }
        ]
      end
    end
  end
end

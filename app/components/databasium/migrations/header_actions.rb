# frozen_string_literal: true

module Components
  module Databasium
    class Migrations::HeaderActions < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::ButtonTo

      def initialize(migration:)
        @migration = migration
      end

      def view_template
        div(id: "header_actions", class: "max-w-full overflow-x-auto") do
          render Components::Databasium::Navigation::IconPanel.new(
                   icons_with_text: [
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
                       path:
                         databasium.rollback_migration_migrations_path(version: @migration.version)
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
                 )
        end
      end
    end
  end
end

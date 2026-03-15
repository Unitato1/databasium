class Components::Databasium::Migrations::HeaderActions < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(migration:)
    @migration = migration
  end

  def view_template
    div(id: "header_actions") do
      render Components::Databasium::Navigation::IconPanel.new(
        icons_with_text: [
          { icon: "arrow-uturn-left", text: "Rollback", path: helpers.rollback_migration_migrations_path(version: @migration.version) },
          { icon: "backward", text: "Rollback till this migration", path: helpers.rollback_migration_migrations_path(version: @migration.version, till_this_migration: true) },
          { icon: "arrow-up", text: "Run Migration", path: helpers.run_migration_migrations_path(version: @migration.version) }
        ]
      )
    end
  end
end

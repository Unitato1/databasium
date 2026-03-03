class Databasium::Migration
  attr_reader :migration_context, :migrations, :pending_migrations, :applied_migrations
  MIGRATIONS_PATHS = [ "db/migrate" ] # TODO: make this configurable and maybe move to a constant readonly

  def initialize
    @migration_context = ActiveRecord::MigrationContext.new(MIGRATIONS_PATHS)
    @migrations = @migration_context.migrations
    @pending_migrations = @migration_context.pending_migration_versions
    @applied_migrations = @migration_context.get_all_versions
  end

  def generate_migration
    @migration.generate_migration
  end

  def find_migration!(version)
    begin
      migration = migration_context.migrations.find { |m| m.version.to_s == version.to_s }
      raise ActiveRecord::RecordNotFound, "Migration not found" unless migration && File.file?(migration.filename)
      [ migration, nil ]
    rescue => e
      [ nil, e ]
    end
  end

  def run_pending_migrations
    begin
      migration_context.pending_migration_versions.each do |version|
        migration_context.run(:up, version)
      end
      true
    rescue => e
      [ false, e ]
    end
  end

  def rollback_migration(version, rollback_steps, till_this_migration)
    begin
      if rollback_steps.present?
        migration_context.rollback(rollback_steps.to_i)
      elsif till_this_migration == "true"
        migration_context.migrate(version.to_i)
      else
        migration_context.run(:down, version.to_i)
      end
    rescue => e
      [ false, e ]
    end
  end

  def run_migration(version)
    begin
      migration_context.run(:up, version.to_i)
      true
    rescue => e
      [ false, e ]
    end
  end

  private
end

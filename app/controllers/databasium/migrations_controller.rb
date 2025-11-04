class Databasium::MigrationsController < Databasium::ApplicationController
  MIGRATIONS_PATHS = ["db/migrate"] 

  def index
    @migrations = migration_context.migrations
    @migraton = migration_context
    @pending_migrations = migration_context.pending_migration_versions
    @applied_migrations = migration_context.get_all_versions
    # https://github.com/rails/rails/blob/3a611889fd174d208c7632c0be43a00ed085924a/activerecord/lib/active_record/migration.rb#L1328
    # for status
    @status = migration_context.migrations_status
    #
    # there is also this way, but it return plain string with just versions the before are with version and name as a object
    # https://github.com/rails/rails/blob/main/activerecord/lib/active_record/schema_migration.rb#L73
    # @schema_migrations = ActiveRecord::SchemaMigration.new( ActiveRecord::Base.connection_pool ).normalized_versions
    if params[:migration]
      @migration = find_migration!(params[:migration])
      @content = File.read(@migration.filename)
    end
  end

  def new
    puts params
  end
  # Might be simplistic approach, but lets start with it,
  # I searched a bit of for how are generataors used in code and what code they actually run
  # We basiclly need same functionality as them, and ability to change the file from UI
  #  https://github.com/rails/rails/blob/main/railties/lib/rails/generators.rb#L263C9-L263C10
  #  I needed to do some reverse engineering to find out how the generator works or more like what it expects
  #  for params, running rails g migration CreateCda name:string
  # gets you this:
  # namespace: migration
  # names: ["migration"]
  # args: ["CreateCda", "name:string"]
  # config: {behavior: :invoke, destination_root: #<Pathname>}
  #  Notes on what I also checked:
  #  https://api.rubyonrails.org/classes/Rails/Generators/Migration.html -> Not much documentation
  #  
  def create
    require 'rails/generators'
    Rails.application.load_generators

    # Hardcoded test invocation
    generator = 'migration'
    args = [
      params[:table_name]
    ]
    if params[:columns].present?
      args += params[:columns].map { |c| "#{c[:column_name]}:#{c[:column_type]}" }
    end
    Rails::Generators.invoke(
      generator,
      args,
      behavior: :invoke,
      destination_root: Rails.root.to_s
    )
  end

  # https://github.com/rails/rails/blob/main/activerecord/lib/active_record/migration.rb#L1414
  private
  # https://github.com/rails/rails/blob/3a611889fd174d208c7632c0be43a00ed085924a/activerecord/lib/active_record/migration.rb#L1206
  def migration_context
    # paths = ActiveRecord::Migrator.migrations_paths
    # self.migrations_paths = ["db/migrate"] https://github.com/rails/rails/blob/main/activerecord/lib/active_record/migration.rb#L1428
    # I dont think this is needed because we are using the default migrations_paths
    # Hm it might be, it seems like there is some way to tweak this elsewhere, maybe I will come back TODO
    ActiveRecord::MigrationContext.new(MIGRATIONS_PATHS)
    # https://github.com/rails/rails/blob/main/activerecord/lib/active_record/migration.rb#L1312
    # I tried to find where could migration be loaded from, this seems like right place
    # there is a lot of of migrations_paths etc. but all seems to be private methods
  end

  def find_migration!(version)
    migration = migration_context.migrations.find { |m| m.version.to_s == version.to_s }
    raise ActiveRecord::RecordNotFound, "Migration not found" unless migration && File.file?(migration.filename)
    migration
  end

end

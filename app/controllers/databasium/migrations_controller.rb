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
    if params[:migration]
      @migration = find_migration!(params[:migration])
      @content = File.read(@migration.filename)
    end
    @tables = (ActiveRecord::Base.connection.tables - %w[ar_internal_metadata schema_migrations]).map(&:classify)
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
  #  https://guides.rubyonrails.org/active_record_migrations.html#running-migrations
  def create
    require 'rails/generators'
    Rails.application.load_generators
    require "rails/generators/active_record/migration/migration_generator"
    
    table_name_with_action = ""
    if params[:add_migration] == "Save" && params[:add_model] == "1"
      generator = 'model'
    else
      table_name_with_action += params[:migration_action]&.capitalize
      generator = 'migration'
    end

    if params[:migration_action] != "create"
      all_affected_columns = params[:columns].present? ?
        params[:columns]
        .filter { |c| c[:column_name].present? && c[:column_type].present? }
        .map { |c| c[:column_name].capitalize }.join("And") : ""
      table_name_with_action += all_affected_columns
    else
      table_name_with_action += params[:table_name]&.capitalize&.pluralize
    end

    if params[:migration_action] == "add"
      table_name_with_action += "To#{params[:table_name_to]&.capitalize&.pluralize}"
    elsif params[:migration_action] == "remove"
      table_name_with_action += "From#{params[:table_name_from]&.capitalize&.pluralize}"
    end

    args = [
      table_name_with_action
    ]

    if params[:columns].present?
      args += params[:columns]
        .filter { |c| c[:column_name].present? && c[:column_type].present? }
        .map { |c| "#{c[:column_name]}:#{c[:column_type]}" }
    end
    
    # args = ["CreateFoos", "name:string"]
    # puts ("args: #{args}")
    
    # puts ("content: #{@content}")
    # puts ("template {destination: #{destination}, source: #{source}, config: #{config}}")
    # source = File.expand_path(find_in_source_paths(source.to_s))

    # set_migration_assigns!(destination)

    # dir, base = File.split(destination)
    # numbered_destination = File.join(dir, ["%migration_number%", base].join("_"))

    # file = create_migration numbered_destination, nil, config do
    #   puts ("result: #{ERB.new(::File.binread(source), trim_mode: "-", eoutvar: "@output_buffer").result(binding)}")
    #   ERB.new(::File.binread(source), trim_mode: "-", eoutvar: "@output_buffer").result(binding)
    # end
    # set_table_model(params[:table_name] || params[:table_name_from] || params[:table_name_to])
    if params[:add_migration] == "Save"
      Rails::Generators.invoke(
        generator,
        args,
        behavior: :invoke,
        destination_root: Rails.root.to_s
      )
      redirect_to migrations_path(migration: migration_context.migrations.last.version)
    else
      gen = ActiveRecord::Generators::MigrationGenerator.new(
        args,
        {},
        behavior: :invoke, destination_root: Rails.root.to_s
      )

      gen.send(:set_local_assigns!)

      puts ("migration template: #{:@migration_template}")
      tmpl = gen.instance_variable_get(:@migration_template)
      source = File.expand_path(gen.find_in_source_paths(tmpl))

      dest = File.join(gen.send(:db_migrate_path), "#{gen.send(:file_name)}.rb")

      gen.send(:set_migration_assigns!, dest)

      @content = ERB.new(File.binread(source), trim_mode: "-", eoutvar: "@output_buffer")
                 .result(gen.instance_eval("binding"))
      respond_to do |format|
        format.html
        format.turbo_stream { render turbo_stream: turbo_stream.replace("migration_preview", partial: "databasium/migrations/components/migration_preview", locals: { content: @content }) }
      end
    end
  end

  def set_table_model(table_name)
    return if table_name.nil?
    table_name_sym = table_name.to_s.downcase.pluralize.to_sym
    if ActiveRecord::Base.connection.table_exists?(table_name_sym)
      begin
        # If there is no model for this table it will raise a NameError
        @model = table_name_sym.classify.constantize
      rescue NameError
        @model = nil
        @error = "No model found for this table, if you would like to interact with this table, you need to create a model for it."
      end
    else
      @model = nil
      @records = nil
    end
  end

  def run_pending_migrations
    begin
      ActiveRecord::Tasks::DatabaseTasks.migrate_all
      if ActiveRecord.dump_schema_after_migration
        connection = ActiveRecord::Tasks::DatabaseTasks.migration_connection
        ActiveRecord::Tasks::DatabaseTasks.dump_schema(connection.pool.db_config)
      end
      flash[:success] = "Pending migrations run successfully"
    rescue => e
      flash[:error] = "Error running pending migrations: #{e.message}"
    end
    redirect_back fallback_location: migrations_path
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

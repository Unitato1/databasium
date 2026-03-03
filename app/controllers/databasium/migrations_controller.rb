class Databasium::MigrationsController < Databasium::ApplicationController
  before_action :create_migration_service
  MIGRATIONS_PATHS = [ "db/migrate" ]

  def index
    @migrations = @migration_service.migrations
    @pending_migrations = @migration_service.pending_migrations
    @applied_migrations = @migration_service.applied_migrations

    unless params[:migration].present?
      render "index" and return
    end

    @migration, error = @migration_service.find_migration!(params[:migration])
    if error
      flash[:error] = error.message
    else
      @content = File.read(@migration.filename)
    end
  end

  def new
    @tables = Databasium::Schema.new.tables
    if params[:migration]
      @migration = @migration_service.find_migration!(params[:migration])
      @content = File.read(@migration.filename)
    end
  end

  def create
    require "rails/generators"
    Rails.application.load_generators
    require "rails/generators/active_record/migration/migration_generator"
    args = build_generator_args
    puts ("args: #{args}")

    if params[:add_migration] == "Save" && params[:add_model] == "1"
      generator = "model"
    else
      generator = "migration"
    end

    puts ("generator: #{generator}")

    if params[:add_migration] == "Save"
      Rails::Generators.invoke(
        generator,
        args,
        behavior: :invoke,
        destination_root: Rails.root.to_s
      )

      redirect_to migrations_path(migration: @migration_service.migrations.last&.version)
    else
      gen = ActiveRecord::Generators::MigrationGenerator.new(
        args,
        {},
        behavior: :invoke, destination_root: Rails.root.to_s
      )

      gen.send(:set_local_assigns!)

      tmpl = gen.instance_variable_get(:@migration_template)
      source = File.expand_path(gen.find_in_source_paths(tmpl))

      dest = File.join(gen.send(:db_migrate_path), "#{gen.send(:file_name)}.rb")

      gen.send(:set_migration_assigns!, dest)

      @content = ERB.new(File.binread(source), trim_mode: "-", eoutvar: "@output_buffer").result(gen.instance_eval("binding"))

      respond_to do |format|
        format.html
        format.turbo_stream { render turbo_stream: turbo_stream.replace("migration_preview", partial: "databasium/migrations/components/migration_preview", locals: { content: @content }) }
      end
    end
  end

  def run_pending_migrations
    success, error = @migration_service.run_pending_migrations
    if success
      flash[:success] = "Pending migrations run successfully"
    else
      flash[:error] = "Error running pending migrations: #{error.message}"
    end

    redirect_back fallback_location: migrations_path
  end

  def rollback_migration
    success, error = @migration_service.rollback_migration(
      rollback_migration_params[:version],
      rollback_migration_params[:rollback_steps],
      rollback_migration_params[:till_this_migration])

    if success
      flash[:success] = "Migration rolled back successfully"
    else
      flash[:error] = "Error rolling back migration: #{error.message}"
    end

    redirect_back fallback_location: migrations_path(migration: rollback_migration_params[:version])
  end

  def run_migration
    success, error = @migration_service.run_migration(run_migration_params[:version])
    if success
      flash[:success] = "Migration run successfully"
    else
      flash[:error] = "Error running migration: #{error.message}"
    end

    redirect_back fallback_location: migrations_path(migration: run_migration_params[:version])
  end

  private

  def create_migration_service
    @migration_service ||= Databasium::Migration.new()
  end

  def run_migration_params
    params.permit(:version)
  end

  def rollback_migration_params
    params.permit(:version, :till_this_migration, :rollback_steps)
  end

  def build_generator_args
    table_name_with_action = params[:add_migration] != "Save" || params[:add_model] != "1" ? params[:migration_action]&.capitalize : ""

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

    not_null_validation = build_not_null_validation
    uniqueness_validation = build_uniqueness_validation
    if params[:columns].present?
      args += params[:columns]
        .filter { |c| c[:column_name].present? && c[:column_type].present? }
        .map { |c| "#{c[:column_name]}:#{c[:column_type]}" + \
        (not_null_validation.include?(c[:column_name]) ? "!" : "") + \
        (uniqueness_validation.include?(c[:column_name]) ? ":uniq" : "")
      }
    end

    args
  end

  def build_not_null_validation
    params[:validation]
    .filter { |c| c[:column_name].present? && c[:type] == "not_null" }
    .map { |c| c[:column_name] }
  end

  def build_uniqueness_validation
    params[:validation]
    .filter { |c| c[:column_name].present? && c[:type] == "uniqueness" }
    .map { |c| c[:column_name] }
  end
end

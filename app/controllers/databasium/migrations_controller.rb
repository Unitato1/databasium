class Databasium::MigrationsController < Databasium::ApplicationController
  before_action :create_migration_service

  def index
    @migrations = @migration_service.migrations
    @pending_migrations = @migration_service.pending_migrations
    @applied_migrations = @migration_service.applied_migrations

    render Views::Databasium::Migrations::Index.new(
             migrations: @migrations,
             pending_migrations: @pending_migrations,
             migration_id: params[:version]
           )
  end

  def show
    @migration, error = @migration_service.find_migration!(params[:id])
    flash[:error] = error&.message
    if @migration
      @content = File.read(@migration.filename)
      respond_to do |format|
        format.html do
          render Components::Databasium::Migrations::File.new(migration: @migration, content: @content)
        end
        format.turbo_stream do
          render Components::Databasium::Migrations::ShowTurboStream.new(migration: @migration, content: @content), layout: false
        end
      end
    else
      render json: { error: "Migration not found" }, status: :not_found
    end
  end

  def new
    @tables = Databasium::Schema.new.tables
    # if params[:migration]
    #   @migration = @migration_service.find_migration!(params[:migration])
    #   @content = File.read(@migration.filename)
    # end
    render Views::Databasium::Migrations::New.new(tables: @tables, content: @content)
  end

  def create
    require "rails/generators"
    Rails.application.load_generators
    require "rails/generators/active_record/migration/migration_generator"

    if params[:add_migration] == "Save"
      success, error = @migration_service.save_migration(params)
    else
      @content, error = @migration_service.generate_migration(params)
    end
    if success || @content
      respond_to do |format|
        format.html do
          redirect_to migrations_path(migration: @migration_service.migrations.last&.version)
        end
        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.replace(
                     "migration_preview",
                     Components::Databasium::Migrations::Preview.new(content: @content)
                   )
        end
      end
    else
      flash[:error] = "Error creating migration: #{error.message}"
      render :new, status: :unprocessable_entity
    end
  end

  def run_pending_migrations
    success, error = @migration_service.run_pending_migrations
    if success
      flash[:success] = "Pending migrations run successfully"
    else
      flash[:error] = "Error running pending migrations: #{error.message}"
    end
    redirect_to migrations_path
  end

  def rollback_migration
    version = rollback_migration_params[:version]
    result, error = @migration_service.rollback_migration(version,
      rollback_migration_params[:rollback_steps],
      rollback_migration_params[:till_this_migration])
    if result == :success
      success = "Migration rolled back successfully"
    else
      error = "Error rolling back migration: #{error.message}"
    end
    if rollback_migration_params[:till_this_migration] == "true" || rollback_migration_params[:rollback_steps].present?
      flash[:success] = success
      flash[:error] = error
      redirect_to migrations_path
      # response_to_action(success, error, version, result == :success ? "pending" : nil)
    else
      response_to_action(success, error, version, result == :success ? "pending" : nil)
    end
  end

  def run_migration
    version = run_migration_params[:version]
    result, error = @migration_service.run_migration(version)
    if result == :success
      success = "Migration run successfully"
    else
      error = "Error running migration: #{error.message}"
    end
    response_to_action(success, error, version, result == :success ? "applied" : nil)
  end

  private

  def create_migration_service
    @migration_service = Databasium::Migration.new
  end

  def migration_params
    params.permit(
      :add_migration,
      :migration_action,
      :table_name,
      :table_name_from,
      :table_name_to,
      :add_model,
      columns: %i[column_name column_type],
      validation: %i[column_name type]
    )
  end

  def run_migration_params
    params.permit(:version)
  end

  def rollback_migration_params
    params.permit(:version, :till_this_migration, :rollback_steps)
  end

  def new_action_response(success, error, migration_version, status)
    Components::Databasium::Migrations::Action.new(
      success: success,
      error: error,
      migration_version: migration_version,
      status: status
    )
  end

  def response_to_action(success, error, migration_version, status)
    respond_to do |format|
      format.turbo_stream do
        render new_action_response(success, error, migration_version, status),
               layout: false
      end
      format.html { redirect_to migrations_path(version: migration_version) }
    end
  end
end

class Databasium::MigrationsController < Databasium::ApplicationController
  before_action :create_migration_service

  def index
    @migrations = @migration_service.migrations
    @pending_migrations = @migration_service.pending_migrations
    @applied_migrations = @migration_service.applied_migrations

    render 'index' and return unless params[:migration].present?

    @migration, error = @migration_service.find_migration!(params[:migration])
    if error
      flash[:error] = error.message
    else
      @content = File.read(@migration.filename)
    end
  end

  def new
    @tables = Databasium::Schema.new.tables
    # if params[:migration]
    #   @migration = @migration_service.find_migration!(params[:migration])
    #   @content = File.read(@migration.filename)
    # end
  end

  def create
    require "rails/generators"
    Rails.application.load_generators
    require "rails/generators/active_record/migration/migration_generator"

    if params[:add_migration] == "Save"
    if params[:add_migration] == 'Save'
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
                     partial: "databasium/migrations/components/migration_preview",
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
      flash[:success] = 'Pending migrations run successfully'
    else
      flash[:error] = "Error running pending migrations: #{error.message}"
    end

    redirect_back fallback_location: migrations_path
  end

  def rollback_migration
    success, error =
      @migration_service.rollback_migration(
        rollback_migration_params[:version],
        rollback_migration_params[:rollback_steps],
        rollback_migration_params[:till_this_migration]
      )

    if success
      flash[:success] = 'Migration rolled back successfully'
    else
      flash[:error] = "Error rolling back migration: #{error.message}"
    end

    redirect_back fallback_location: migrations_path(migration: rollback_migration_params[:version])
  end

  def run_migration
    success, error = @migration_service.run_migration(run_migration_params[:version])
    if success
      flash[:success] = 'Migration run successfully'
    else
      flash[:error] = "Error running migration: #{error.message}"
    end

    redirect_back fallback_location: migrations_path(migration: run_migration_params[:version])
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
end

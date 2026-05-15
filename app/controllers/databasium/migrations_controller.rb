class Databasium::MigrationsController < Databasium::ApplicationController
  before_action :create_migration_service
  after_action -> { Databasium::Schema.new.sync! },
               only: %i[run_migration rollback_migration run_pending_migrations]
  include Pagy::Method

  def index
    render Views::Databasium::Migrations::Index.new
  end

  def show
    @migration, _ = @migration_service.find_migration!(params[:id])
    return render json: { error: "Migration not found" }, status: :not_found unless @migration

    @content = File.read(@migration.filename)
    respond_to do |format|
      format.html do
        render Components::Databasium::Migrations::File.new(
                  migration: @migration,
                  content: @content
                )
      end
      format.turbo_stream do
        render Components::Databasium::Migrations::ShowTurboStream.new(
                  migration: @migration,
                  content: @content
                ),
                layout: false
      end
    end
  end

  def new
    @tables = Databasium::Schema.new.tables
    render Views::Databasium::Migrations::New.new(tables: @tables)
  end

  def create
    require "rails/generators"
    Rails.application.load_generators
    require "rails/generators/active_record/migration/migration_generator"

    if params[:add_migration] == "Save"
      success = @migration_service.save_migration(params)
    else
      content = @migration_service.generate_migration(params)
    end

    if success
      flash[:success] = "Migration for table #{params[:table_name]} saved successfully."
      redirect_to migrations_path, status: :see_other
    elsif content
      render turbo_stream:
                turbo_stream.replace(
                  "migration_preview",
                  Components::Databasium::Migrations::Preview.new(content: content)
                )
    else
      render :new, status: :unprocessable_entity
    end
  end

  def sidebar
    set_pagy_migrations_and_pending_migrations

    render Components::Databasium::SearchResults::Migrations.new(
      migrations: @migrations,
      pending_migrations: @pending_migrations,
      pagy: @pagy
    )
  end

  def run_pending_migrations
    versions = @migration_service.run_pending_migrations
    message =
      if versions.any?
        "Pending migrations(#{versions.count}) run successfully"
      else
        "No pending migrations to run"
      end

    respond_to do |format|
      format.html { redirect_to migrations_path, notice: message }
      format.turbo_stream do
        streams = [
          turbo_stream.replace("error", Components::Databasium::Global::Error.new),
          turbo_stream.replace(
            "flash",
            Components::Databasium::Global::Flash.new(success: message, error: nil)
          )
        ]

        streams +=
          versions.map do |version|
            turbo_stream.replace(
              "migration_#{version}_status",
              Components::Databasium::Migrations::MigrationStatus.new(
                status: "applied",
                version: version
              )
            )
          end

        render turbo_stream: streams
      end
    end
  end

  def rollback_migration
    version = rollback_migration_params[:version]
    result, error =
      @migration_service.rollback_migration(
        version,
        rollback_migration_params[:rollback_steps],
        rollback_migration_params[:till_this_migration]
      )
    success = "Migration rolled back successfully" if result == :success
    if rollback_migration_params[:till_this_migration] == "true" ||
         rollback_migration_params[:rollback_steps].present?
      set_action_flash(success, error)
      redirect_to migrations_path(version: version)
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

  def set_pagy_migrations_and_pending_migrations
    @pagy, @migrations =
    pagy(@migration_service.get_migrations(params[:search]), limit: 7, root_key: "migrations")
    @pending_migrations = @migration_service.pending_migrations
  end

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
        render new_action_response(success, error, migration_version, status), layout: false
      end
      format.html do
        set_action_flash(success, error)
        redirect_to migrations_path(version: migration_version)
      end
    end
  end

  def set_action_flash(success, error)
    flash[:success] = success if success.present?
    flash[:error] = error if error.present?
  end
end

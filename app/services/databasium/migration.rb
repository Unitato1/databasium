
class Databasium::Migration
  attr_reader :migration_context, :migrations, :pending_migrations, :applied_migrations
  MIGRATIONS_PATHS = [ "db/migrate" ] # TODO: make this configurable and maybe move to a constant readonly
  MIGRATIONS_TEMPLATE_PATH = Databasium::Engine.root.join("lib/databasium/templates/migration.rb.tt")
  CREATE_TABLE_MIGRATIONS_TEMPLATE_PATH = Databasium::Engine.root.join("lib/databasium/templates/create_table_migration.rb.tt")
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
      [ :success, nil ]
    rescue => e
      [ :failed, e ]
    end
  end

  def rollback_migration(version, rollback_steps, till_this_migration)
    begin
      if rollback_steps.present?
        migration_context.rollback(rollback_steps.to_i)
      elsif till_this_migration == "true"
        migration_context.down(version.to_i)
      else
        migration_context.run(:down, version.to_i)
      end
      [ :success, nil ]
    rescue => e
      [ :failed, e ]
    end
  end

  def run_migration(version)
    begin
      migration_context.run(:up, version.to_i)
      [ :success, nil ]
    rescue => e
      [ :failed, e ]
    end
  end

  def save_migration(params)
    require "rails/generators/active_record/migration/migration_generator"
    require "rails/generators"
    Rails.application.load_generators
    args = build_generator_args(params)
    if params[:add_migration] == "Save" && params[:add_model] == "1"
      generator = "model"
    else
      generator = "migration"
    end
      begin
        Rails::Generators.invoke(
          generator,
          args,
          behavior: :invoke,
          destination_root: Rails.root.to_s
        )
        true
      rescue => e
        [ false, e ]
      end
  end

  def generate_migration(params)
    require "rails/generators/active_record/migration/migration_generator"
    require "rails/generators"
    Rails.application.load_generators
    args = build_generator_args(params)
    gen = ActiveRecord::Generators::MigrationGenerator.new(
      args,
      {},
      behavior: :invoke, destination_root: Rails.root.to_s
    )

    gen.send(:set_local_assigns!)
    gen.set_migration_assigns!(gen.file_name)

    if params[:migration_action] == "create"
      source = CREATE_TABLE_MIGRATIONS_TEMPLATE_PATH
    else
      source = MIGRATIONS_TEMPLATE_PATH
    end
    content = ERB.new(File.read(source), trim_mode: "-", eoutvar: "@output_buffer").result(gen.instance_eval("binding"))
    [ content, nil ]
  end

  private

  def build_generator_args(params)
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

    not_null_validation = build_not_null_validation(params)
    uniqueness_validation = build_uniqueness_validation(params)
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

  def build_not_null_validation(params)
    params[:validation]
    .filter { |c| c[:column_name].present? && c[:type] == "not_null" }
    .map { |c| c[:column_name] }
  end

  def build_uniqueness_validation(params)
    params[:validation]
    .filter { |c| c[:column_name].present? && c[:type] == "uniqueness" }
    .map { |c| c[:column_name] }
  end
end

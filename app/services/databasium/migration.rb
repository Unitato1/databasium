class Databasium::Migration
  attr_reader :migration_context, :migrations, :pending_migrations
  MIGRATIONS_PATHS = [ "db/migrate" ]
  MIGRATIONS_TEMPLATE_PATH =
    Databasium::Engine.root.join("lib/databasium/templates/migration.rb.tt")
  CREATE_TABLE_MIGRATIONS_TEMPLATE_PATH =
    Databasium::Engine.root.join("lib/databasium/templates/create_table_migration.rb.tt")

  def initialize
    @migration_context = ActiveRecord::MigrationContext.new(MIGRATIONS_PATHS)
    @migrations = @migration_context.migrations
    @pending_migrations = @migration_context.pending_migration_versions
  end

  def get_migrations(search)
    return @migrations unless search.present?
    @migrations.select { |m| m.name =~ /#{Regexp.escape(search)}/i } if search
  end

  def find_migration!(version)
    migration = migration_context.migrations.find { |m| m.version.to_s == version.to_s }
    unless migration && File.file?(migration.filename)
      raise ActiveRecord::RecordNotFound, "Migration #{version} not found"
    end
    migration
  end

  def run_pending_migrations
    versions = migration_context.pending_migration_versions
    begin
      versions.each { |version| migration_context.run(:up, version) }
    rescue => e
      raise "There was an error running the pending migrations: #{e.message}"
    end
    versions
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
    rescue => e
      raise "There was an error rolling back the #{version} migration: #{e.message}"
    end
  end

  def run_migration(version)
    begin
      migration_context.run(:up, version.to_i)
    rescue => e
      raise "There was an error running the #{version} migration: #{e.message}"
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
    Rails::Generators.invoke(generator, args, behavior: :invoke, destination_root: Rails.root.to_s)
    true
  end

  def generate_migration(params)
    unless params[:table_name_from].present? || params[:table_name_to].present? || params[:table_name].present?
      raise "Please provide a table name to generate a migration"
    end

    require "rails/generators/active_record/migration/migration_generator"
    require "rails/generators"
    Rails.application.load_generators
    args = build_generator_args(params)
    gen =
      ActiveRecord::Generators::MigrationGenerator.new(
        args,
        {},
        behavior: :invoke,
        destination_root: Rails.root.to_s
      )

    gen.send(:set_local_assigns!)
    gen.set_migration_assigns!(gen.file_name)

    if params[:migration_action] == "create"
      source = CREATE_TABLE_MIGRATIONS_TEMPLATE_PATH
    else
      source = MIGRATIONS_TEMPLATE_PATH
    end
    ERB.new(File.read(source), trim_mode: "-", eoutvar: "@output_buffer").result(
      gen.instance_eval("binding")
    )
  end

  private

  def build_generator_args(params)
    table_name_with_action = set_generator_base(params)

    table_name_with_action += if params[:migration_action] != "create"
      set_all_affected_columns(params)
    else
      params[:table_name]&.capitalize&.pluralize
    end

    table_name_with_action += if params[:migration_action] == "add"
      "To#{params[:table_name_to]&.capitalize&.pluralize}"
    elsif params[:migration_action] == "remove"
      "From#{params[:table_name_from]&.capitalize&.pluralize}"
    else
      ""
    end

    generator_args = [ table_name_with_action ]

    generator_args += set_contrains_on_columns(params)
  end

  def set_generator_base(params)
    if params[:add_migration] != "Save" || params[:add_model] != "1"
      params[:migration_action]&.capitalize
    else
      ""
    end
  end

  def set_all_affected_columns(params)
    return "" unless params[:columns].present?
    if params[:columns].size > 4
      "Columns"
    else
      params[:columns]
        .filter { |c| c[:column_name].present? && c[:column_type].present? }
        .map { |c| c[:column_name].capitalize }
        .join("And")
    end
  end

  def set_contrains_on_columns(params)
    return nil unless params[:columns].present?
    not_null_validation = build_not_null_validation(params)
    uniqueness_validation = build_uniqueness_validation(params)

    params[:columns]
      .filter { |c| c[:column_name].present? && c[:column_type].present? }
      .map do |c|
        "#{c[:column_name]}:#{c[:column_type]}" +
          (not_null_validation.include?(c[:column_name]) ? "!" : "") +
          (uniqueness_validation.include?(c[:column_name]) ? ":uniq" : "")
      end
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

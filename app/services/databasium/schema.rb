class Databasium::Schema
  attr_reader :schema, :tables
  def initialize
    @conn = ActiveRecord::Base.connection
    @tables = @conn.data_sources - %w[ar_internal_metadata schema_migrations]
  end

  def sync!
    path = Rails.root.join("storage")
    FileUtils.mkdir_p(path) unless Dir.exist?(path)
    File.write(path.join("schema_graph.json"), build_schema.to_json)
  end

  def get_associations(table)
    model =
      ActiveRecord::Base.descendants.find { |m| m.table_name == table } ||
        table.classify.safe_constantize
    if model
      model.reflect_on_all_associations.map do |r|
        {
          name: r.name.to_s.pluralize,
          macro: r.macro,
          class_name: r.class_name,
          foreign_key: r.foreign_key
        }
      end
    else
      []
    end
  end

  def schema
    if File.exist?(Rails.root.join("storage/schema_graph.json")) && @schema.nil?
      @schema ||= JSON.parse(File.read(Rails.root.join("storage/schema_graph.json")))
    else
      @schema ||= build_schema
      sync!
    end
    @schema
  end

  def get_model_and_layers_BFS(model, layers)
    queue = Queue.new()
    queue.push([model.downcase.pluralize, 0])
    result = {}
    until queue.empty?
      model, layer = queue.pop

      next if (layers.present? && layer > layers) || result[model].present?
      result[model] = get_schema_for_model(model)

      model_associations = result[model].fetch("associations", []).map { |a| a["name"] }
      model_associations.each { |association| queue << [association, layer + 1] }
    end
    result
  end

  def get_schema_for_model(model)
    schema[model.downcase.pluralize]
  end

  def get_model_associations(model)
    model_associations = schema[model.downcase.pluralize].fetch(:associations, [])
    result = { "#{model.downcase.pluralize}": get_schema_for_model(model) }
    model_associations.each do |association|
      association_key = association[:class_name].downcase.pluralize

      result[association_key] = get_schema_for_model(association[:class_name])
    end
    result
  end

  def get_foreign_keys(table)
    @all_references ||=
      @conn
        .foreign_keys(table)
        .map do |fk|
          { from: fk.from_table, to: fk.to_table, column: fk.column, primary_key: fk.primary_key }
        end
    @all_references
  end

  def get_columns_from_table(table)
    @conn
      .columns(table)
      .map { |c| { name: c.name, sql_type: c.sql_type, null: c.null, default: c.default } }
  end

  def get_columns_names(table)
    @conn.columns(table).map { |c| c.name }
  end

  def get_tables(search)
    @tables = @tables.select { |table| table =~ /#{search}/i } if search
    @tables
  end

  def get_columns(model)
    return if model.nil?
    model.columns.map do |column|
      {
        name: column.name,
        type: column.type.to_s,
        used: false,
        foreign_key: is_column_foreign_key?(model.table_name, column.name),
        to_table: get_foreign_key_to_table(model.table_name, column.name)
      }
    end
  end

  def get_model_from_table(table)
    return nil, "Select a table to view its records." if table.nil?
    table_name = table.downcase.pluralize.to_sym
    unless ActiveRecord::Base.connection.table_exists?(table_name)
      return nil, "Table #{table} does not exist"
    end
    begin
      # If there is no model for this table it will raise a NameError
      @model = table.classify.constantize
      @error = nil
    rescue NameError
      @model = nil
      @error =
        "No model found for this table,
        if you would like to interact with this table, you need to create a model for it."
    end
    [@model, @error]
  end

  def filter_records(records, filter)
    return records if filter.nil? || @model.nil?
    connectors = Array(filter[:operator_types]).map(&:to_s)
    allowed_operators = %w[eq not_eq gt lt gteq lteq matches does_not_match]
    combined_predicate = nil
    predicate_index = 0

    filter
      .except(:operator_types)
      .each do |name, value|
        next if value[:operator].blank? || value[:value].blank?

        operator = value[:operator].to_s
        next unless allowed_operators.include?(operator)

        column = @model.arel_table[name]
        predicate_value = value[:value].to_s
        predicate_value = "%#{predicate_value}%" if %w[matches does_not_match].include?(operator)
        current_predicate = column.public_send(operator, predicate_value)

        if combined_predicate.nil?
          combined_predicate = current_predicate
        else
          connector = connectors[predicate_index - 1] == "or" ? :or : :and
          combined_predicate = combined_predicate.public_send(connector, current_predicate)
        end

        predicate_index += 1
      end

    return records if combined_predicate.nil?

    records.where(combined_predicate)
  end

  def build_schema
    @schema = {}
    @tables.each do |table|
      @schema[table] = {
        columns: get_columns_from_table(table),
        foreign_keys: get_foreign_keys(table),
        associations: get_associations(table)
      }
    end
    @schema
  end

  def is_column_foreign_key?(table, column_name)
    @all_references ||= get_foreign_keys(table)
    @all_references.any? { |fk| fk[:column] == column_name }
  end

  def get_foreign_key_to_table(table, column_name)
    @all_references ||= get_foreign_keys(table)
    fk = @all_references.find { |fk| fk[:column] == column_name }
    fk[:to] if fk
  end
end

class Databasium::Schema
  attr_reader :schema, :tables
  def initialize
    @conn = ActiveRecord::Base.connection
    @tables = @conn.data_sources - %w[ar_internal_metadata schema_migrations]
    @schema = nil
  end

  def sync!(schema: nil)
    path = Rails.root.join("storage")
    FileUtils.mkdir_p(path) unless Dir.exist?(path)
    File.write(path.join("schema_graph.json"), (schema || build_schema).to_json)
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
    return @schema unless @schema.nil?
    if File.exist?(Rails.root.join("storage/schema_graph.json"))
      @schema = JSON.parse(File.read(Rails.root.join("storage/schema_graph.json")))
    else
      @schema = build_schema.deep_stringify_keys
      sync!(schema: @schema)
      @schema
    end
  end

  def get_model_and_layers_BFS(model, layers)
    queue = Queue.new()
    queue.push([ table_name_for(model), 0 ])
    result = {}

    until queue.empty?
      table, layer = queue.pop
      next if (layers.present? && layer > layers) || result[table].present?
      result[table] = get_schema_for_model(table)

      model_associations = result[table].fetch("associations", nil)
      model_associations&.each { |a| queue << [ a["name"], layer + 1 ] }
    end
    result
  end

  def get_schema_for_model(model)
    schema[table_name_for(model)]
  end

  def get_foreign_keys(table)
    @conn
      .foreign_keys(table)
      .map do |fk|
        { from: fk.from_table, to: fk.to_table, column: fk.column, primary_key: fk.primary_key }
      end
  end

  def get_columns_from_table(table)
    @conn
      .columns(table)
      .map { |c| { name: c.name, sql_type: c.sql_type, null: c.null, default: c.default } }
  end

  def get_columns_names(table)
    @conn.columns(table_name_for(table)).map { |c| c.name }
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
    table_name = table_name_for(table)
    unless ActiveRecord::Base.connection.table_exists?(table_name)
      return nil, "Table #{table} does not exist"
    end
    begin
      # If there is no model for this table it will raise a NameError
      @model =
        ActiveRecord::Base.descendants.find { |model| model.table_name == table_name } ||
          table_name.classify.constantize
      @error = nil
    rescue NameError
      @model = nil
      @error =
        "No model found for this table,
        if you would like to interact with this table, you need to create a model for it."
    end
    [ @model, @error ]
  end

  private

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

  def table_name_for(name)
    name.to_s.tableize
  end

  def is_column_foreign_key?(table, column_name)
    get_foreign_keys(table).any? { |fk| fk[:column] == column_name }
  end

  def get_foreign_key_to_table(table, column_name)
    get_foreign_keys(table).find { |fk| fk[:column] == column_name }&.fetch(:to)
  end
end

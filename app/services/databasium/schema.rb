class Databasium::Schema
  attr_reader :schema, :tables
  def initialize
    @conn = ActiveRecord::Base.connection
    @tables = @conn.data_sources - %w[ar_internal_metadata schema_migrations]
  end

  def get_associations(table)
    model = ActiveRecord::Base.descendants.find { |m| m.table_name == table } || table.classify.safe_constantize
    model ? model.reflect_on_all_associations.map { |r| { name: r.name.to_s.pluralize, macro: r.macro, class_name: r.class_name, foreign_key: r.foreign_key } } : []
  end

  def schema
    @schema ||= build_schema
  end

  def get_foreign_keys(table)
    @all_references ||= @conn.foreign_keys(table).map { |fk| { from: fk.from_table, to: fk.to_table, column: fk.column, primary_key: fk.primary_key } }
    @all_references
  end

  def get_columns_from_table(table)
    @conn.columns(table).map { |c| { name: c.name, sql_type: c.sql_type, null: c.null, default: c.default } }
  end

  def get_columns_names(table)
    @conn.columns(table).map { it.name }
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
    return [ nil, "Select a table to view its records." ] if table.nil?
    table_name = table.downcase.pluralize.to_sym
    unless ActiveRecord::Base.connection.table_exists?(table_name)
      return [ nil, "Table #{table} does not exist" ]
    end
    begin
      # If there is no model for this table it will raise a NameError
      @model = table.classify.constantize
      @error = nil
    rescue NameError
      @model = nil
      @error =
        'No model found for this table,
        if you would like to interact with this table, you need to create a model for it.'
    end
    [ @model, @error ]
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

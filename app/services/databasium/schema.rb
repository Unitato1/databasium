class Databasium::Schema
  attr_reader :schema
  def initialize
    @conn = ActiveRecord::Base.connection
    @tables = @conn.data_sources - %w[ar_internal_metadata schema_migrations]
    @schema ||= build_schema
  end

  def get_associations(table)
    model = ActiveRecord::Base.descendants.find { |m| m.table_name == table } || table.classify.safe_constantize
    model ? model.reflect_on_all_associations.map { |r| { name: r.name.to_s.pluralize, macro: r.macro, class_name: r.class_name, foreign_key: r.foreign_key } } : []
  end

  def get_foreign_keys(table)
    @conn.foreign_keys(table).map { |fk| { from: fk.from_table, to: fk.to_table, column: fk.column, primary_key: fk.primary_key } }
  end

  def get_columns(table)
    @conn.columns(table).map { |c| { name: c.name, sql_type: c.sql_type, null: c.null, default: c.default } }
  end

  def build_schema
    @schema = {}
    @tables.each do |table|
      @schema[table] = {
        columns: get_columns(table),
        foreign_keys: get_foreign_keys(table),
        associations: get_associations(table)
      }
    end
    puts "schema: #{@schema}"
    puts "schema: #{@schema.inspect}"
    @schema
  end
end

class Databasium::SchemasController < Databasium::ApplicationController
  def index
    @tables = set_tables
    schema_service = Databasium::Schema.new
    @schema = schema_service.schema
  end

  private

  def set_tables
    @tables = (ActiveRecord::Base.connection.data_sources - %w[ar_internal_metadata schema_migrations])
  end
end

class Databasium::SchemasController < Databasium::ApplicationController
  def index
    schema_service = Databasium::Schema.new
    @tables = schema_service.tables
    @schema = schema_service.schema
  end
end

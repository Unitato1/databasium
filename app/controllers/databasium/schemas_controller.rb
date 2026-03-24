class Databasium::SchemasController < Databasium::ApplicationController
  def index
    @schema = Databasium::Schema.new.schema
    render Views::Databasium::Schemas::Index.new(schema: @schema)
  end
end

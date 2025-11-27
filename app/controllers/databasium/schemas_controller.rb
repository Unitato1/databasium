class Databasium::SchemasController < Databasium::ApplicationController
  def index
    @tables = set_tables
  end

  private

  def set_tables
    @tables = (ActiveRecord::Base.connection.tables - %w[ar_internal_metadata schema_migrations]).map(&:classify)
  end
end

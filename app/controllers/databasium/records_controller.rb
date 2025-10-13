class Databasium::RecordsController < Databasium::ApplicationController
  def index
    @tables = (ActiveRecord::Base.connection.tables - %w[ar_internal_metadata schema_migrations]).map(&:classify)
    search_tables
    set_viewing_table
    apply_filters
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end


  private

  def search_tables
    if params[:search]
      @tables = @tables.select { |table| table =~ /#{params[:search]}/i }
    end
    @tables
  end

  def set_viewing_table
    return if params[:table].nil?
    table_name = params[:table].downcase.pluralize.to_sym
    if ActiveRecord::Base.connection.table_exists?(table_name)
      @model = params[:table].classify.constantize
      @records = @model.all
    else
      @model = nil
      @records = nil
    end
  end
  def apply_filters
    return if @model.nil? || @records.nil?
    @columns_names_types = @model.columns.map { |column| { name: column.name, type: column.type.to_s, used: false } }
  end
end

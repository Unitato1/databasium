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
    filter_params&.each do |name, value|
      if value[:operator].present? && value[:value].present?
        if value[:operator] == "matches"
          @records = @records.where(@model.arel_table[name].matches("%#{value[:value]}%"))
        else
          @records = @records.where(@model.arel_table[name].send(value[:operator], value[:value]))
        end
      end
    end
  end

  def filter_params
    allowed_columns = @model.columns.map { |c| c.name.to_s }

    params.fetch(:filter, {}).permit(
      allowed_columns.index_with { |_col| [:operator, :value] }
    )
  end
end

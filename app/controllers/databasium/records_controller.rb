class Databasium::RecordsController < Databasium::ApplicationController
  before_action :create_schema_service, only: [:index]

  def index
    @tables = @schema_service.tables
    search_tables
    set_viewing_table

    if @model && @records
      @columns_names_types ||= @model.columns.map { |column| { name: column.name, type: column.type.to_s, used: false } }
      apply_filters
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end


  private

  def create_schema_service
    @schema_service = Databasium::Schema.new
  end

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
      begin
        # If there is no model for this table it will raise a NameError
        @model = params[:table].classify.constantize
        @records = @model.all
      rescue NameError
        @model = nil
        @records = nil
        @error = "No model found for this table, if you would like to interact with this table, you need to create a model for it."
      end
    else
      @model = nil
      @records = nil
    end
  end

  def apply_filters
    return if params[:filter].nil?
    puts "#{filter_params.inspect}"
    filter_params&.each do |name, value|
      if value[:operator].present? && value[:value].present?
        if value[:operator] == "matches" || value[:operator] == "does_not_match"
          @records = @records.where(@model.arel_table[name].send(value[:operator], "%#{value[:value]}%"))
        else
          @records = @records.where(@model.arel_table[name].send(value[:operator], value[:value]))
        end
      end
    end
  end

  def filter_params
    allowed_columns = @model.columns.map { |c| c.name.to_s }

    params.require(:filter).permit(
      allowed_columns.index_with { |_col| [:operator, :value] }
    )
  end
end

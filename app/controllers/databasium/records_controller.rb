class Databasium::RecordsController < Databasium::ApplicationController
  before_action :create_schema_service, only: [ :index, :foreign_records, :records ]
  include Pagy::Method

  def index
    search_tables
    if @tables
      @pagy_tables, @tables = pagy(@tables, limit: 5, root_key: "tables")
    end
    set_viewing_table
    set_columns_names_types
    apply_filters

    if @records
      @pagy, @records = pagy(@records, limit: 10, root_key: "records")
    end
    render Views::Databasium::Records::Index.new(records: @records, model: @model, turbo_frame: @turbo_frame_id || "records", pagy: @pagy)
  end

  def create
    create_schema_service
    set_viewing_table
    return unless @model
    record = @model.new(model_columns)
    if record.save
      @records = @model.all
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            "records_list",
            partial: "record",
            locals: { record: record }
          )
        end
      end
    end
  end

  def foreign_records
    set_viewing_table
    if @model
      @records = @model.all
    end
    set_columns_names_types
    apply_filters
    if @records
      @pagy, @records = pagy(@records, limit: 10, root_key: "records")
    end
  end

  def records
    set_viewing_table
    set_columns_names_types
    apply_filters

    if @records
      @pagy, @records = pagy(@records, limit: 10, root_key: "records")
    end
    @turbo_frame_id = params[:frame_id].presence || "records"
    if @turbo_frame_id == "foreign_records"
      render "foreign_records"
    else
      render Components::Databasium::Records.new(records: @records, model: @model, turbo_frame: @turbo_frame_id || "records", pagy: @pagy)
    end
  end
  private

  def create_schema_service
    @schema_service = Databasium::Schema.new
  end

  def search_tables
    @tables = @schema_service.tables
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

  def set_columns_names_types
    if @model
      @columns_names_types ||= @model.columns.map { |column| {
        name: column.name,
        type: column.type.to_s,
        used: false,
        foreign_key: @schema_service.is_column_foreign_key?(@model.table_name, column.name),
        to_table: @schema_service.get_foreign_key_to_table(@model.table_name, column.name) }
      }
    end
  end

  def apply_filters
    return if params[:filter].nil? || @model.nil?
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
      allowed_columns.index_with { |_col| [ :operator, :value ] }
    )
  end

  def model_columns
    return if params[:table].nil?
    table_name = params[:table].downcase.pluralize.to_sym
    params.require(:record).permit(
      *@schema_service.get_columns_names(table_name)
    )
  end
end

class Databasium::RecordsController < Databasium::ApplicationController
  before_action :create_schema_service
  include Pagy::Method

  def index
    @pagy_tables, @tables =
      pagy(@schema_service.get_tables(params[:search]), limit: 5, root_key: "tables")
    @model, @error = @schema_service.get_model_from_table(params[:table])
    @columns_names_types = @schema_service.get_columns(@model)

    render Views::Databasium::Records::Index.new(
             model: @model,
             columns_names_types: @columns_names_types,
             table: params[:table],
             tables: @tables,
             pagy_tables: @pagy_tables
           )
  end

  def create
    @model, @error = @schema_service.get_model_from_table(params[:table])
    record = @model&.new(model_columns_params)
    if record && record.save
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.append(
                     "records_list",
                     Components::Databasium::Records::NewRecordsRow.new(record: record)
                   )
        end
      end
    end
  end

  def records
    @model, @feedback = @schema_service.get_model_from_table(params[:table])
    @records = @model&.all
    @columns_names_types = @schema_service.get_columns(@model)
    @records = @schema_service.filter_records(@records, params[:filter])
    @pagy, @records = pagy(@records, limit: 10, root_key: "records") if @records
    @turbo_frame_id = params[:frame_id].presence || "records"
    if @turbo_frame_id == "foreign_records"
      render Components::Databasium::Records::ForeignRecords.new(
               model: @model,
               columns_names_types: @columns_names_types
             )
    else
      render Components::Databasium::Records::Table.new(
               records: @records,
               model: @model,
               turbo_frame: @turbo_frame_id || "records",
               pagy: @pagy,
               feedback: @feedback
             )
    end
  end

  private

  def create_schema_service
    @schema_service = Databasium::Schema.new
  end

  def filter_params
    allowed_columns = @model.columns.map { |c| c.name.to_s }

    params.require(:filter).permit(
      allowed_columns.index_with { |_col| %i[operator value] },
      operator_types: []
    )
  end

  def model_columns_params
    return if params[:table].nil?
    table_name = params[:table].downcase.pluralize.to_sym
    params.require(:record).permit(*@schema_service.get_columns_names(table_name))
  end
end

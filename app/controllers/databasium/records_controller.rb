class Databasium::RecordsController < Databasium::ApplicationController
  before_action :create_schema_service
  include Pagy::Method
  include ActionView::RecordIdentifier

  def index
    @pagy_tables, @tables =
      pagy(@schema_service.get_tables(params[:search]), limit: 10, root_key: "tables")
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
    @filter = filter_params
    @records = @model&.all
    @columns_names_types = @schema_service.get_columns(@model)
    @records = @schema_service.filter_records(@records, @filter)
    @pagy, @records =
      pagy(@records, limit: params[:limit].presence || 10, root_key: "records") if @records
    @turbo_frame_id = params[:frame_id].presence || "records"
    @limit = params[:limit].presence || 10
    @refresh = params[:refresh].presence || false
    if @turbo_frame_id == "foreign_records"
      render Components::Databasium::Records::ForeignRecords.new(
               model: @model,
               columns_names_types: @columns_names_types
             )
    else
      respond_to do |format|
        format.html do
          render Components::Databasium::Records::Table.new(
                   records: @records,
                   model: @model,
                   turbo_frame: @turbo_frame_id || "records",
                   pagy: @pagy,
                   feedback: @feedback,
                   columns_names_types: @columns_names_types
                 )
        end
        format.turbo_stream do
          render Components::Databasium::Records::ShowTurboStream.new(
                   refresh: @refresh,
                   filter: @filter,
                   table: params[:table],
                   records: @records,
                   model: @model,
                   turbo_frame: @turbo_frame_id || "records",
                   pagy: @pagy,
                   feedback: @feedback,
                   columns_names_types: @columns_names_types,
                   limit: @limit
                 ),
                 layout: false
        end
      end
    end
  end

  def bulk_destroy
    ids = params[:ids]
    @model, @feedback = @schema_service.get_model_from_table(params[:table])
    records = @model&.where(id: ids)
    return head :unprocessable_entity if records.nil?
    doms_ids = records.map { |record| dom_id(record) }
    if records&.destroy_all
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: (doms_ids&.map { |dom_id| turbo_stream.remove(dom_id) })
        end
        format.html { head :ok }
      end
    end
  end

  private

  def destroy_params
    params.permit([:id])
  end

  def create_schema_service
    @schema_service = Databasium::Schema.new
  end

  def filter_params
    return nil if @model.nil?
    allowed_columns = @model&.columns.map { |c| c.name.to_s }

    params.fetch(:filter, {}).permit(
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

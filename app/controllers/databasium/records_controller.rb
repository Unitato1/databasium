class Databasium::RecordsController < Databasium::ApplicationController
  before_action :create_schema_service
  before_action :set_model_and_record_service
  include Pagy::Method
  include ActionView::RecordIdentifier

  def index
    @pagy_tables, @tables =
      pagy(@schema_service.get_tables(params[:search]), limit: 10, root_key: "tables")

    render Views::Databasium::Records::Index.new(
             model: @model,
             table: params[:table],
             tables: @tables,
             pagy_tables: @pagy_tables
           )
  end

  def create
    new_record = @record_service.create_new(attributes: model_columns_params)
    raise ActiveRecord::RecordInvalid, record.errors.full_messages.join(", ") unless new_record

    render turbo_stream: [
      turbo_stream.append(
        "records_body",
        Components::Databasium::Records::Table::Row.new(
          record: new_record,
          turbo_frame: "records_list"
        )
      ),
      turbo_stream.remove("suggestion")
    ]
  end

  def records
    @context = records_context
    @pagy, @records =
      pagy(@record_service.filter_records(filter_params), limit: params[:limit].presence || 10, root_key: "records")

    if foreign_records_frame?(@context[:turbo_frame])
      render_foreign_records_table
    else
      respond_to do |format|
        format.html { render_records_table }
        format.turbo_stream { render_records_table_turbo_stream }
      end
    end
  end

  def update
    record = @record_service.update_by_id(params[:id], attributes: model_columns_params)
    raise ActiveRecord::RecordInvalid, record.errors.full_messages.join(", ") unless record
    render turbo_stream:
      turbo_stream.replace(
        dom_id(record),
        Components::Databasium::Records::Table::Row.new(
          record: record,
          turbo_frame: "records_list"
        )
      )
  end

  def bulk_destroy
    deleted_records = @record_service.bulk_destroy(params[:ids])
    raise ActiveRecord::RecordInvalid, deleted_records.errors.full_messages.join(", ") unless deleted_records

    doms_ids = deleted_records.map { |record| dom_id(record) }

    render turbo_stream:
      doms_ids.flat_map { |dom_id|
        [
          turbo_stream.remove(dom_id),
          turbo_stream.remove("record-tab-#{dom_id}"),
          turbo_stream.remove("record-form-#{dom_id}")
        ]
      }
  end

  private

  def render_foreign_records_table
    render Components::Databasium::Records::ForeignRecords.new(
      model: @model,
      columns_names_types: @context[:columns_names_types],
      frame_id: @context[:turbo_frame]
    )
  end

  def render_records_table_turbo_stream
    render Components::Databasium::Records::ShowTurboStream.new(
      **@context,
      records: @records,
      pagy: @pagy,
   ),
   layout: false
  end

  def render_records_table
    render Components::Databasium::Records::Table.new(
      records: @records,
      model: @context[:model],
      turbo_frame: @context[:turbo_frame],
      pagy: @context[:pagy],
      feedback: @context[:feedback],
    )
  end

  def records_context
    {
      refresh: params[:refresh].presence || false,
      filter: filter_params,
      table: params[:table],
      model: @model,
      turbo_frame: params[:frame_id].presence || "records_list",
      feedback: @feedback,
      columns_names_types: @schema_service.get_columns(@model),
      limit: params[:limit].presence || 10
    }
  end
  #   @refresh = refresh
  # @filter = filter
  #   @table = table
  #   @records = records
  #   @model = model
  #   @turbo_frame = turbo_frame
  #   @pagy = pagy
  #   @feedback = feedback
  #   @columns_names_types = columns_names_types
  #   @limit = limit
  def set_model_and_record_service
    @model, @feedback = @schema_service.get_model_from_table(params[:table])
    @record_service = Databasium::Record.new(model: @model)
  end

  def create_schema_service
    @schema_service = Databasium::Schema.new
  end

  def foreign_records_frame?(frame_id)
    frame_id.start_with?("foreign_records_") && !foreign_records_table_frame?(frame_id)
  end

  def foreign_records_table_frame?(frame_id)
    frame_id.start_with?("foreign_records_table_")
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
    params.require(:record).permit(*@schema_service.get_columns_names(params[:table]))
  end
end

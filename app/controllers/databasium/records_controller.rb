class Databasium::RecordsController < Databasium::ApplicationController
  before_action :create_schema_service, only: %i[index foreign_records records]
  include Pagy::Method

  def index
    search_tables
    @pagy_tables, @tables = pagy(@tables, limit: 5, root_key: "tables") if @tables
    set_viewing_table
    set_columns_names_types
    apply_filters

    @pagy, @records = pagy(@records, limit: 10, root_key: "records") if @records
    render Views::Databasium::Records::Index.new(
             records: @records,
             model: @model,
             turbo_frame: @turbo_frame_id || "records",
             pagy: @pagy
           )
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
          render turbo_stream:
                   turbo_stream.append(
                     "records_list",
                     partial: "record",
                     locals: {
                       record: record
                     }
                   )
        end
      end
    end
  end

  def foreign_records
    set_viewing_table
    @records = @model.all if @model
    set_columns_names_types
    apply_filters
    @pagy, @records = pagy(@records, limit: 10, root_key: "records") if @records
  end

  def records
    set_viewing_table
    set_columns_names_types
    apply_filters

    @pagy, @records = pagy(@records, limit: 10, root_key: "records") if @records
    @turbo_frame_id = params[:frame_id].presence || "records"
    if @turbo_frame_id == "foreign_records"
      render "foreign_records"
    else
      render Components::Databasium::Records.new(
               records: @records,
               model: @model,
               turbo_frame: @turbo_frame_id || "records",
               pagy: @pagy
             )
    end
  end

  private

  def create_schema_service
    @schema_service = Databasium::Schema.new
  end

  def search_tables
    @tables = @schema_service.tables
    @tables = @tables.select { |table| table =~ /#{params[:search]}/i } if params[:search]
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
        @error =
          'No model found for this table,
          if you would like to interact with this table, you need to create a model for it.'
      end
    else
      @model = nil
      @records = nil
    end
  end

  def set_columns_names_types
    if @model
      @columns_names_types ||=
        @model.columns.map do |column|
          {
            name: column.name,
            type: column.type.to_s,
            used: false,
            foreign_key: @schema_service.is_column_foreign_key?(@model.table_name, column.name),
            to_table: @schema_service.get_foreign_key_to_table(@model.table_name, column.name)
          }
        end
    end
  end

  def apply_filters
    return if params[:filter].nil? || @model.nil?
    connectors = Array(filter_params[:operator_types]).map(&:to_s)
    allowed_operators = %w[eq not_eq gt lt gteq lteq matches does_not_match]
    combined_predicate = nil
    predicate_index = 0

    filter_params
      .except(:operator_types)
      .each do |name, value|
        next if value[:operator].blank? || value[:value].blank?

        operator = value[:operator].to_s
        next unless allowed_operators.include?(operator)

        column = @model.arel_table[name]
        predicate_value = value[:value].to_s
        predicate_value = "%#{predicate_value}%" if %w[matches does_not_match].include?(operator)
        current_predicate = column.public_send(operator, predicate_value)

        if combined_predicate.nil?
          combined_predicate = current_predicate
        else
          connector = connectors[predicate_index - 1] == "or" ? :or : :and
          combined_predicate = combined_predicate.public_send(connector, current_predicate)
        end

        predicate_index += 1
      end

    return if combined_predicate.nil?

    @records = @records.where(combined_predicate)
  end

  def filter_params
    allowed_columns = @model.columns.map { |c| c.name.to_s }

    params.require(:filter).permit(
      allowed_columns.index_with { |_col| %i[operator value] },
      operator_types: []
    )
  end

  def model_columns
    return if params[:table].nil?
    table_name = params[:table].downcase.pluralize.to_sym
    params.require(:record).permit(*@schema_service.get_columns_names(table_name))
  end
end

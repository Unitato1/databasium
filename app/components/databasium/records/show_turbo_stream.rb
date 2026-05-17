class Components::Databasium::Records::ShowTurboStream < Components::Base
  include Phlex::Rails::Helpers::TurboStream

  def initialize(
    refresh:,
    filter:,
    table:,
    records:,
    model:,
    turbo_frame:,
    pagy:,
    feedback:,
    columns_names_types:,
    limit:
  )
    @filter = filter
    @table = table
    @records = records
    @model = model
    @turbo_frame = turbo_frame
    @pagy = pagy
    @feedback = feedback
    @columns_names_types = columns_names_types
    @limit = limit
    @refresh = refresh
  end

  def view_template
    foreign = @turbo_frame.start_with?("foreign_records_table_")
    target_frame = foreign ? @turbo_frame : "records_list"

    turbo_stream.replace(
      target_frame,
      Components::Databasium::Records::Table.new(
        records: @records,
        model: @model,
        turbo_frame: target_frame,
        pagy: @pagy,
        feedback: @feedback
      )
    )

    return if foreign

    turbo_stream.update(
      "header_actions",
      Components::Databasium::Records::HeaderActions.new(filter: nil, table: @table, limit: @limit)
    )
    if @refresh
      turbo_stream.replace(
        "filter",
        Components::Databasium::Records::Filter.new(
          model: @model,
          turbo_frame: @turbo_frame,
          columns_names_types: @columns_names_types,
          hidden: true
        )
      )
      turbo_stream.replace(
        "addRecord",
        Components::Databasium::Forms::Model.new(
          columns_names_types: @columns_names_types,
          model: @model
        )
      )
      turbo_stream.replace(
        "records_utilities",
        Components::Databasium::Records::Utilities.new(
          model: @model,
          columns_names_types: @columns_names_types
        )
      )
    end
  end
end

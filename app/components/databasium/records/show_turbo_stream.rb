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
    turbo_stream.replace(
      "records_list",
      Components::Databasium::Records::CleanTable.new(
        records: @records,
        model: @model,
        turbo_frame: @turbo_frame,
        pagy: @pagy,
        feedback: @feedback,
        columns_names_types: @columns_names_types
      )
    )
    turbo_stream.update(
      "header_actions",
      Components::Databasium::Records::HeaderActions.new(
        filter: @filter,
        table: @table,
        limit: @limit
      )
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
        "add_record",
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

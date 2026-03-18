class Components::Databasium::Records::ShowTurboStream < Components::Base
  include Phlex::Rails::Helpers::TurboStream

  def initialize(table:, records:, model:, turbo_frame:, pagy:, feedback:, columns_names_types:, limit:)
    @table = table
    @records = records
    @model = model
    @turbo_frame = turbo_frame
    @pagy = pagy
    @feedback = feedback
    @columns_names_types = columns_names_types
    @limit = limit
  end

  def view_template
    turbo_stream.replace(
      "records_list",
      Components::Databasium::Records::Table.new(records: @records, model: @model, turbo_frame: @turbo_frame, pagy: @pagy, feedback: @feedback, columns_names_types: @columns_names_types)
    )
    turbo_stream.replace(
      "header_actions",
      Components::Databasium::Records::HeaderActions.new(table: @table, limit: @limit)
    )
  end
end

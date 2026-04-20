class Components::Databasium::Records::Table::Row < Components::Base
  include Phlex::Rails::Helpers::DOMID
  attr_reader :record

  def initialize(record:, turbo_frame:)
    @record = record
    @turbo_frame = turbo_frame
  end

  def view_template
    tr(
      id: dom_id(record),
      class: "hover:bg-background hover:cursor-pointer",
      data: {
        action: "click->table-select#selectRecord click->table#selectRecord dblclick->table#appendRecordCard",
        record_id: record.id
      }
    ) do
      if @turbo_frame == "records"
        td(
          class: "text-center w-55 max-w-55 py-2 border-1 border-border overflow-auto",
        ) do
          input(
            type: "checkbox",
            id: "#{record.id}",
            name: "ids[]",
            value: record.id,
            data: {
              table_target: "checkbox"
            }
          )
        end
      end
      record.class.columns.each do |column|
        td(
          class: "text-center w-55 max-w-55 py-2 border-1 border-border overflow-auto",
            data: { attribute_name: column.name }
        ) { plain format_cell_value(record.public_send(column.name)) }
      end
    end
  end

  def format_cell_value(value)
    case value
    when Time, DateTime, ActiveSupport::TimeWithZone
      value.strftime("%Y-%m-%d %H:%M:%S")
    when Date
      value.strftime("%Y-%m-%d")
    when File
      link_to value.url, value.url, target: "_blank"
    else
      value.to_s
    end
  end
end

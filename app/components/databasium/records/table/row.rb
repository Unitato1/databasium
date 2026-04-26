class Components::Databasium::Records::Table::Row < Components::Base
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::ClassNames

  attr_reader :record

  def initialize(record:, turbo_frame:, render_as_cards: false)
    @record = record
    @turbo_frame = turbo_frame
    @render_as_cards = render_as_cards
  end

  def view_template
    if @render_as_cards
      render_card
    else
      render_row
    end
  end

  private

  def click_action
    @turbo_frame == "records_list" ? "click->table#handleClick" : "click->table-select#selectRecord"
  end

  def render_card
    article(
      id: dom_id(record),
      class:
        "flex flex-col border-1 border-border rounded-md bg-panel " \
        "hover:bg-background hover:cursor-pointer overflow-hidden min-w-0 w-full max-w-125",
      data: {
        action: click_action,
        record_id: record.id
      }
    ) do
      record.class.columns.each { |column| render_card_field(column) }
    end
  end

  def render_card_field(column)
    div(
      class:
        "grid grid-cols-2 divide-x divide-border " \
        "border-b-1 border-border last:border-b-0 py-1",
      data: {
        attribute_name: column.name
      }
    ) do
      div(class: "text-base font-semibold px-2 overflow-x-auto whitespace-nowrap min-w-0 max-w-full") { column.name }
      div(class: "text-base font-light px-2 overflow-x-auto whitespace-nowrap min-w-0 max-w-full") do
        format_cell_value(record.public_send(column.name))
      end
    end
  end

  def render_row
    tr(
      id: dom_id(record),
      class: "hover:bg-background hover:cursor-pointer",
      data: {
        action: click_action,
        record_id: record.id
      }
    ) do
      render_checkbox if @turbo_frame == "records_list"
      record.class.columns.each { |column| render_plain_td(column) }
    end
  end

  def render_checkbox
    td(class: "text-center py-2 border-1 border-border overflow-auto") do
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

  def render_plain_td(column)
    td(
      class: "text-center w-55 max-w-55 py-2 border-1 border-border overflow-auto",
      data: {
        attribute_name: column.name
      }
    ) { plain format_cell_value(record.public_send(column.name)) }
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

module Components
  module Databasium
    class Records::Table::RecordPanel < Components::Base
      def initialize
      end

      def view_template
        div(class: "flex flex-col min-h-0 items-end") do
          div(
            class: "hidden bg-panel flex-1 min-h-0 overflow-y-auto rounded-bl-xl mb-2 min-h-[calc(100dvh-51px)] flex flex-col w-125",
              data: { table_target: "recordsPanel" },
              id: "editRecord"
          ) do
            button(
              class: "w-fit text-accent hover:text-accent-dark border-1 border-accent p-1 rounded-xl m-2 ms-auto",
              data: { action: "click->table#closeRecordsPanel" }) do
                raw heroicon("x-mark", variant: :solid, options: { class: "w-6 h-6" })
            end
            div(class: "flex bg-background px-2 overflow-x-auto max-w-fill divide-x-1 divide-border gap-x-2", data: { table_target: "recordTabs" }) do
              template(data: { table_target: "recordTab" }) do
                button(type: "button", class: "flex items-center gap-2 px-2 cursor-pointer", data: { action: "click->table#openTab" }) do
                  div(data: { table_target: "recordTabTitle" }) { plain "Name" }
                  div(data: { action: "click->table#closeTab" }) do
                    raw heroicon("x-mark", variant: :solid, options: { class: "w-3 h-3 me-auto hover:bg-panel" })
                  end
                end
              end
            end
            div(class: "m-2", data: { table_target: "recordTabsContent" }) { plain "Double click on a record to update to open update form" }
          end
        end
      end
    end
  end
end

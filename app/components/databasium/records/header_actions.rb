# frozen_string_literal: true

module Components
  module Databasium
    class Records::HeaderActions < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::ButtonTo
      LIMITS = [ 10, 20, 50, 100 ].freeze
      def initialize(filter:, table:, limit:)
        @filter = filter
        @table = table
        @limit = limit
      end

      def view_template
        div(id: "header_actions", class: "flex tems-center") do
          limit = @limit.to_i
          button(
            type: "submit",
            form: "delete_records_form",
            data: {
              turbo_stream: true
            },
            class: "hidden bg-accent px-4 py-1 rounded-xl text-base me-2"
          ) { span(data: { table_target: "deleteButton" }) { } }

          render Components::Databasium::Navigation::IconPanel.new(
                   icons_with_text: [
                     {
                       icon: "funnel",
                       text: "filter",
                       method: :frontend,
                       data_params: {
                         toggle: "filter",
                         action: "click->toggle#toggle"
                       }
                     },
                     {
                       icon: "plus-circle",
                       text: "add",
                       method: :frontend,
                       data_params: {
                         toggle: "addRecord",
                         action: "click->toggle#toggle"
                       }
                     },
                     {
                       icon: "pencil-square",
                       text: "edit",
                       method: :frontend,
                       data_params: {
                         toggle: "editRecord",
                         action: "click->toggle#toggleSticky"
                       }
                     },
                    {
                      icon: "chevron-double-up",
                      text: "10",
                      method: :get,
                      turbo_frame: "records_list",
                      path: records_path(),
                      active: limit == 10
                    },
                    {
                      icon: "chevron-double-up",
                      text: "20",
                      method: :get,
                      turbo_frame: "records_list",
                      path: records_path(limit: 20),
                      active: limit == 20
                    },
                    {
                      icon: "chevron-double-up",
                      text: "50",
                      method: :get,
                      turbo_frame: "records_list",
                      path: records_path(limit: 50),
                      active: limit == 50
                    },
                    {
                      icon: "chevron-double-up",
                      text: "100",
                      method: :get,
                      turbo_frame: "records_list",
                      path: records_path(limit: 100),
                      active: limit == 100
                    }
                   ]
                 )
        end
      end

      private

      def records_path(limit: 10)
        databasium.records_records_path(
          table: @table,
          frame_id: "records_list",
          filter: @filter,
          limit: limit
        )
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class Records::HeaderActions < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::ButtonTo
      LIMITS = [ 10, 20, 50, 100 ].freeze
      def initialize(table:, limit:)
        @table = table
        @limit = limit
      end

      def view_template
        div(id: "header_actions") do
          limit = @limit.to_i
          render Components::Databasium::Navigation::IconPanel.new(
            icons_with_text: [
              { icon: "plus-circle", text: "add record", method: :frontend },
              { icon: "funnel", text: "filter", method: :frontend },
              { icon: "chevron-double-up", text: "10", method: :get, turbo_frame: "records", path: records_path, active: limit == 10 },
              { icon: "chevron-double-up", text: "20", method: :get, turbo_frame: "records", path: records_path(limit: 20), active: limit == 20 },
              { icon: "chevron-double-up", text: "50", method: :get, turbo_frame: "records", path: records_path(limit: 50), active: limit == 50 },
              { icon: "chevron-double-up", text: "100", method: :get, turbo_frame: "records", path: records_path(limit: 100), active: limit == 100 }
            ]
          )
        end
      end

      private

      def records_path(limit: 10)
        databasium.records_records_path(table: @table, frame_id: "records", limit: limit)
      end
    end
  end
end

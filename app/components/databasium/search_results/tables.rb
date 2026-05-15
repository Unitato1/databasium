# frozen_string_literal: true

module Components
  module Databasium
    class SearchResults::Tables < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(tables:, pagy:)
        @tables = tables
        @pagy = pagy
      end

      def view_template
        turbo_frame_tag("results") do
          @tables&.each do |table|
            div(class: "border-b-2 border-b-border py-2 px-3") do
              link_to "#{table}",
                      databasium.records_records_path(table: table, refresh: true),
                      data: {
                        turbo_frame: "_top",
                        turbo_stream: true
                      }
            end
          end
          div(class: "mt-4 flex justify-start") { raw @pagy.series_nav.html_safe } if @pagy
        end
      end
    end
  end
end

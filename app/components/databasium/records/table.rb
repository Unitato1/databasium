# frozen_string_literal: true

module Components
  module Databasium
    class Records::Table < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(records:, model:, turbo_frame:, pagy: nil, feedback: nil, columns_names_types:)
        @records = records
        @model = model
        @turbo_frame = turbo_frame
        @pagy = pagy
        @feedback = feedback
        @columns_names_types = columns_names_types
      end

      def view_template
        turbo_frame_tag(@turbo_frame, class: "flex min-h-0 min-w-0 flex-1 flex-col") do
          div(id: "records_utilities") { }
          render_table
        end
      end

      private

      def render_table
        turbo_frame_tag("records_list") do
          render Components::Databasium::Global::Suggestion.new(
                   suggestions: [ @feedback || "No records found for #{@model&.name} table." ]
                 )
        end
      end
    end
  end
end

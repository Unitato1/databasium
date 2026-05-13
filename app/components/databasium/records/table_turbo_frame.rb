# frozen_string_literal: true

module Components
  module Databasium
    class Records::TableTurboFrame < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(model:, turbo_frame:, feedback: nil)
        @model = model
        @turbo_frame = turbo_frame
        @feedback = feedback
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

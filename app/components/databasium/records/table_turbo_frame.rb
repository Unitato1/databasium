# frozen_string_literal: true

module Components
  module Databasium
    class Records::TableTurboFrame < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(model: nil, feedback: nil)
        @model = model
        @feedback = feedback
      end

      def view_template
        div(class: "flex min-h-0 min-w-0 flex-1 flex-col") do
          div(id: "records_utilities") { }
          render_table
        end
      end

      private

      def render_table
        turbo_frame_tag("records_list") do
          suggestion = if @feedback
            @feedback
          elsif @model
            "No records found for #{@model&.name} table."
          else
            "Please select a table to view records."

          end
          render Components::Databasium::Global::Suggestion.new(
                   suggestions: [ suggestion ]
                 )
        end
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class SearchResults::Models < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(models:, pagy:)
        @models = models
        @pagy = pagy
      end

      def view_template
        turbo_frame_tag("results") do
          @models&.each do |model|
            link_to(
              databasium.model_path(model),
              data: {
                turbo_frame: "main"
              },
              class:
                "text-main-text hover:text-hover hover:cursor-pointer flex items-center gap-2 p-1 border-b
                  border-border flex items-center justify-between"
            ) do
              p(class: "max-w-fit overflow-x-auto me-2 scrollbar-thin p-1") do
                "#{model.upcase_first}"
              end
            end
          end
          div(class: "mt-4 flex justify-start") { raw @pagy.series_nav.html_safe } if @pagy
        end
      end
    end
  end
end

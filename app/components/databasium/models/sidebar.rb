# frozen_string_literal: true

module Components
  module Databasium
    class Models::Sidebar < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(models:, pagy:)
        @models = models
        @pagy = pagy
      end

      def view_template
        render_models_list
      end

      private

      def render_models_list
        div(class: "flex flex-col gap-2", data: { controller: "search" }) do
          render_search_for_models
          turbo_frame_tag("results") do
            render_models
          end
        end
        div(class: "mt-4 flex justify-start") { raw @pagy.series_nav.html_safe } if @pagy
      end

      def render_models
        @models&.each do |model|
            link_to(
              databasium.get_model_models_path(model: model),
              data: {
                turbo_stream: true
              },
              class: "text-main-text hover:text-hover hover:cursor-pointer flex items-center gap-2 p-1 border-b
                border-border flex items-center justify-between"
            ) do
              p(class: "max-w-fit overflow-x-auto me-2 scrollbar-thin p-1") { "#{model.name}" }
            end
        end
      end

      def render_search_for_models
        render Components::Databasium::Forms::Search.new(
          url: databasium.new_model_path,
          turbo_frame: "results",
          placeholder: "Search for a model"
        )
      end
    end
  end
end

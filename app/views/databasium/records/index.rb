# frozen_string_literal: true

module Views
  module Databasium
    class Records::Index < Views::Base
      include Phlex::Rails::Helpers::ContentFor

      def initialize(model:)
        @model = model
      end

      def view_template
        content_for(:title) { "Records" }
        div(class: "flex px-4 gap-4") do
          div(class: "") do
            render_sidebar
          end
          div(class: "w-full") do
            render_main
          end
        end
      end

      private

      def render_sidebar
        raw helpers.render(partial: "databasium/records/components/sidebar")
      end

      def render_main
        raw helpers.render(partial: "databasium/records/components/main")
      end
    end
  end
end

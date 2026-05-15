# frozen_string_literal: true

module Views
  module Databasium
    class Migrations::New < Views::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(tables:)
        @tables = tables
      end

      def view_template
        div(class: "flex p-4 gap-4") do
          render Components::Databasium::Migrations::Form.new(tables: @tables, content: @content)
          div(class: "flex-1 pe-4") do
            render Components::Databasium::Migrations::Preview.new(content: nil)
          end
        end
      end
    end
  end
end

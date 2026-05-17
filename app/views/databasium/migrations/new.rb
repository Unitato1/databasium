# frozen_string_literal: true

module Views
  module Databasium
    class Migrations::New < Views::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::ContentFor

      def initialize(tables:)
        @tables = tables
      end

      def view_template
        content_for(:title) { "New Migration" }
        content_for(:sidebar) { render Components::Databasium::Migrations::Sidebar.new }
        content_for(:header_actions) do
          render Components::Databasium::Migrations::HeaderActions.new(migration: nil)
        end
        div(class: "flex p-4 gap-4") do
          render Components::Databasium::Migrations::Form.new(tables: @tables, content: nil)
          div(class: "flex-1 pe-4") do
            render Components::Databasium::Migrations::Preview.new(content: nil)
          end
        end
      end
    end
  end
end

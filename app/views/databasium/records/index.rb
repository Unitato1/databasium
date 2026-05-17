# frozen_string_literal: true

module Views
  module Databasium
    class Records::Index < Views::Base
      include Phlex::Rails::Helpers::ContentFor
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::LinkTo

      def initialize
      end

      def view_template
        content_for(:title) { "Records" }
        content_for(:sidebar) { render Components::Databasium::Records::Sidebar.new }
        div(class: "flex min-h-0 min-w-0 flex-1") do
          render Components::Databasium::Records::TableTurboFrame.new
          render Components::Databasium::Records::Table::RecordPanel.new
        end
      end
    end
  end
end

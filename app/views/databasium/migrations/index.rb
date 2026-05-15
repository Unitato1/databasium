module Views
  module Databasium
    class Migrations::Index < Views::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::ContentFor

      def initialize
      end

      def view_template
        content_for(:title) { "Migrations" }
        content_for(:sidebar) do
          render Components::Databasium::Migrations::Sidebar.new(
            migrations: nil,
            pending_migrations: nil,
            pagy: nil)
        end
        render_migration_frame
      end

      private

      def render_migration_frame
        turbo_frame_tag "migration", class: "flex-1" do
          render Components::Databasium::Global::Suggestion.new(
                    suggestions: [ "Select a migration to see the file" ]
                  )
        end
      end
    end
  end
end

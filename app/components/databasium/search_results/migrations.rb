# frozen_string_literal: true

module Components
  module Databasium
    class SearchResults::Migrations < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(migrations:, pending_migrations:, pagy:)
        @migrations = migrations
        @pending_migrations = pending_migrations
        @pagy = pagy
      end

      def view_template
        turbo_frame_tag("results") do
          @migrations.each do |m|
            status = @pending_migrations.include?(m.version) ? "pending" : "applied"
            link_to(
              databasium.migration_path(m.version),
              data: {
                turbo_stream: true
              },
              class:
                "text-main-text hover:text-hover hover:cursor-pointer flex items-center gap-2 p-1 border-b
                  border-border flex items-center justify-between"
            ) do
              p(class: "max-w-fit overflow-x-auto me-2 scrollbar-thin p-1") { "#{m.name}" }
              render Migrations::MigrationStatus.new(status: status, version: m.version)
            end
          end
          div(class: "mt-4 flex justify-start") { raw @pagy.series_nav.html_safe } if @pagy
        end
      end
    end
  end
end

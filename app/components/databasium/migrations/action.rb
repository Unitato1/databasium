module Components
  module Databasium
    class Migrations::Action < Components::Base
      include Phlex::Rails::Helpers::TurboStream

      def initialize(success:, error:, migration_version:, status:)
        @success = success
        @error = error
        @migration_version = migration_version
        @status = status
      end

      def view_template
        render_flash_stream
        render_migration_status_stream
      end

      private
      def render_flash_stream
        turbo_stream.replace(
          "flash",
          Components::Databasium::Global::Flash.new(success: @success, error: @error)
        )
      end

      def render_migration_status_stream
        turbo_stream.replace(
          "migration_#{@migration_version}_status",
          Components::Databasium::Migrations::MigrationStatus.new(
            status: @status,
            version: @migration_version
          )
        )
      end
    end
  end
end

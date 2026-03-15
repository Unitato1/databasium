class Components::Databasium::Migrations::ShowTurboStream < Components::Base
  include Phlex::Rails::Helpers::TurboStream

  def initialize(migration:, content:)
    @migration = migration
    @content = content
  end

  def view_template
    turbo_stream.replace("migration", Components::Databasium::Migrations::File.new(migration: @migration, content: @content))
    turbo_stream.replace("header_actions", Components::Databasium::Migrations::HeaderActions.new(migration: @migration))
  end
end

# frozen_string_literal: true

module Views
end

module Components
  extend Phlex::Kit
end

engine_views_path = Databasium::Engine.root.join("app/views")
engine_components_path = Databasium::Engine.root.join("app/components")

if engine_views_path.directory?
  Rails.autoloaders.main.push_dir(engine_views_path, namespace: Views)
end

if engine_components_path.directory?
  Rails.autoloaders.main.push_dir(engine_components_path, namespace: Components)
end

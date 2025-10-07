module Databasium
  class Engine < ::Rails::Engine
    isolate_namespace Databasium

    initializer "databasium.assets" do |app|
      app.config.assets.precompile += %w[ databasium_manifest.js ]
    end

    initializer "databasium.importmap", before: "importmap" do |app|
      if app.respond_to?(:config) && app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end
    end
  end
end

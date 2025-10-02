module Databasium
  class Engine < ::Rails::Engine
    isolate_namespace Databasium

    initializer "databasium.assets" do |app|
      app.config.assets.precompile += %w[ databasium_manifest.js ]
    end
  end
end

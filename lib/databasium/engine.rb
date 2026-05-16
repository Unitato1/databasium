# frozen_string_literal: true

require "databasium/engine_mount"
require "databasium/middleware/conditional_check_pending"

module Databasium
  class Engine < ::Rails::Engine
    isolate_namespace Databasium

    config.databasium = ActiveSupport::OrderedOptions.new

    initializer "databasium.development_only" do
      if Rails.env.production?
        abort "
          Databasium gem must not be loaded in production.
          Add databasium only to the :development group.
          It will not even allow you to load your application in production or when you run RAILS_ENV=production locally.
          Do not add it to the default group."
      end
    end

    initializer "databasium.configuration" do |app|
      app.config.databasium ||= ActiveSupport::OrderedOptions.new
    end

    initializer "databasium.clear_mount_path_cache" do |app|
      app.config.to_prepare { Databasium::EngineMount.clear_mount_path_cache! }
    end

    # Prevent the default global middleware; we insert a scoped version below.
    initializer "databasium.skip_global_pending_migration_check",
                before: "active_record.migration_error" do |app|
      app.config.active_record.migration_error = :ignore if Rails.env.development?
    end

    initializer "databasium.conditional_check_pending",
                after: "active_record.migration_error" do |app|
      next unless Rails.env.development?

      app.middleware.insert_after(
        ActionDispatch::Callbacks,
        Databasium::Middleware::ConditionalCheckPending,
        file_watcher: app.config.file_watcher
      )
    end

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

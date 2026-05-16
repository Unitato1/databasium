# frozen_string_literal: true

module Databasium
  module EngineMount
    module_function

    def mount_path
      explicit = Rails.application.config.databasium&.mount_path
      return normalize_path(explicit) if explicit.present?

      detected_mount_path
    end

    def clear_mount_path_cache!
      @detected_mount_path = nil
    end

    def detected_mount_path
      @detected_mount_path ||= find_mount_path_from_routes
    end

    def find_mount_path_from_routes
      route = Rails.application.routes.routes.find { |r| databasium_route?(r) }
      normalize_path(route&.path&.spec&.to_s) || "/databasium"
    end

    def databasium_route?(route)
      app = route.app
      app == Databasium::Engine || (app.respond_to?(:app) && app.app == Databasium::Engine)
    end

    def normalize_path(path)
      cleaned = path.to_s.split("(").first.presence || "/"
      cleaned == "/" ? "/" : cleaned.chomp("/")
    end
  end
end

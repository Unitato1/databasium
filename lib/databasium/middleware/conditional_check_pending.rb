# frozen_string_literal: true

module Databasium
  module Middleware
    class ConditionalCheckPending < ActiveRecord::Migration::CheckPending
      def call(env)
        request = ActionDispatch::Request.new(env)
        return @app.call(env) if databasium_request?(request)

        super
      end

      private

      def databasium_request?(request)
        prefix = mount_path
        path = request.path

        path == prefix || path.start_with?("#{prefix}/")
      end

      def mount_path
        Databasium::EngineMount.mount_path
      end
    end
  end
end

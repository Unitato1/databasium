module Databasium
  class ApplicationController < ActionController::Base
    helper ::Databasium::HeroiconHelper

    layout -> { Views::Layouts::Databasium::Application.new }
    before_action :check_development_environment

    rescue_from Exception, with: :render_error_flash if Rails.env.development?

    private

    def check_development_environment
      render Views::Databasium::Errors::NonDevelopment.new if Rails.env.production?
    end

    def render_error_flash(error)
      Rails.logger.error("[Databasium] #{error.class}: #{error.message}")
      Rails.logger.error(error.backtrace.join("\n")) if error.backtrace

      return if performed?

      message, details = error_message_parts(error)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
                   turbo_stream.replace(
                     "flash",
                     Components::Databasium::Global::Flash.new(
                       success: flash[:success],
                       error: flash[:error]
                     )
                   ),
                   turbo_stream.replace(
                     "error",
                     Components::Databasium::Global::Error.new(
                       message: message,
                       details: details,
                       type: error.class.name
                     )
                   )
                 ],
                 status: :internal_server_error
        end
        format.any do
          render Components::Databasium::Global::Error.new(
                   message: message,
                   details: details,
                   type: error.class.name
                 ),
                 status: :internal_server_error
        end
      end
    end

    def error_message_parts(error)
      lines = strip_ansi(error.message.to_s).lines.map(&:chomp)
      message = lines.shift.presence || "Something went wrong"
      details = lines.join("\n")

      [ message, details.presence || strip_ansi(error.backtrace&.join("\n").to_s).presence ]
    end

    def strip_ansi(text)
      text.gsub(/\e\[[0-9;]*m/, "")
    end
  end
end

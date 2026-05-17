# frozen_string_literal: true

module Components
  module Databasium
    class Global::Error < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(message: nil, details: nil, type: nil)
        @message = message
        @details = details
        @type = type
      end

      def view_template
        div(id: "error") do
          div(
            class:
              "absolute top-20 left-1/2 -translate-x-1/2 px-4 z-50 transition-opacity duration-1000 ease-in-out",
            data: {
              controller: "error"
            }
          ) { render_error if @message || @details }
        end
      end

      private

      def render_error
        div(
          class:
            "bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-xl shadow-md lg:w-4xl mx-auto relative overflow-y-auto max-h-100",
          role: "alert"
        ) do
          button(
            type: "button",
            class: "absolute right-4 top-1",
            data: {
              action: "click->error#close"
            }
          ) do
            heroicon("x-mark", variant: :solid, options: { class: "w-8 h-8 hover:cursor-pointer" })
          end
          h2(class: "font-bold pr-10") { @type || "Error" }
          p(class: "block whitespace-pre-wrap pr-10") { @message }
          render_details if @details.present?
        end
      end

      def render_details
        details(class: "mt-3") do
          summary(class: "cursor-pointer font-semibold") { "Details" }
          pre(
            class:
              "mt-2 max-h-64 overflow-auto whitespace-pre rounded-lg bg-red-50 p-2 font-mono text-xs"
          ) { plain @details }
        end
      end
    end
  end
end

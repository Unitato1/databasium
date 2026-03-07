# frozen_string_literal: true

module Components
  module Databasium
    class Global::Flash < Components::Base
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(success: nil, error: nil)
        @success = success
        @error = error
      end

      def view_template
        turbo_frame_tag "flash" do
          div(class: "absolute top-20 left-1/2 -translate-x-1/2 px-4 z-50 transition-opacity duration-1000 ease-in-out", data: { controller: "flash" }) do
            render_success if @success
            render_error if @error
          end if @success || @error
        end
      end

      private

      def render_success
        div(class: "bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-xl shadow-md lg:w-4xl mx-auto relative", role: "alert") do
          button(type: "button", class: "absolute right-4 top-1", data: { action: "click->flash#close" }) do
            helpers.heroicon("x-mark", variant: :solid, options: { class: "w-8 h-8 hover:cursor-pointer" })
          end
          h2(class: "font-bold border-b-1 border-b-gray-300") { "Success!" }
          p(class: "block") { @success }
        end
      end

      def render_error
        div(class: "bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-xl shadow-md lg:w-4xl mx-auto relative", role: "alert") do
          button(type: "button", class: "absolute right-4 top-1", data: { action: "click->flash#close" }) do
            helpers.heroicon("x-mark", variant: :solid, options: { class: "w-8 h-8 hover:cursor-pointer" })
          end
          h2(class: "font-bold") { "Error!" }
          p(class: "block") { @error }
        end
      end
    end
  end
end

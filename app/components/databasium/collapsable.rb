# frozen_string_literal: true

module Components
  module Databasium
    class Collapsable < Components::Base
      def initialize(name: nil, form: nil, class_name: nil, data_targets: {}, name_params: nil)
        @name = name
        @form = form
        @class_name = class_name
        @data_targets = data_targets
        @name_params = name_params || {}
      end

      def view_template(&block)
        form(&block)
      end

      private

      def form(&block)
        div(class: @class_name ? @class_name : "flex gap-4 border-b border-gray-300 pb-4", data: @data_targets) do
          div(class: "relative w-full", data: { controller: "collapse" }) do
            button(data: { action: "click->collapse#toggle" }, class: "flex items-center justify-between w-full h-fit hover:cursor-pointer") do
              if @form
                raw @form.label(@name, class: "text-lg font-semibold")
              else
                h2(class: "text-lg font-semibold", **@name_params) { @name }
              end
              raw helpers.heroicon("chevron-down", variant: :solid, options: { class: "w-8 h-8 text-red-500", data_collapse_target: "collapseIcon" })
            end
            div(class: "flex flex-col mt-2 hidden", data: { collapse_target: "content" }) do
              div(class: "relative w-full") do
                div(class: "flex flex-col gap-2 mt-2") do
                  yield if block_given?
                end
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Components
  module Databasium
    class Collapsable < Components::Base
      def initialize(
        name: nil,
        form: nil,
        class_name: nil,
        data_targets: {},
        name_params: nil,
        target_container: nil
      )
        @name = name
        @form = form
        @class_name = class_name
        @data_targets = data_targets
        @name_params = name_params || {}
        @target_container = target_container
      end

      def view_template(&block)
        form(&block)
      end

      private

      def form(&block)
        div(
          class: @class_name ? @class_name : "w-full border-1 border-border rounded-xl p-3",
          data: @data_targets
        ) do
          div(data: { controller: "collapse" }) do
            button(
              data: {
                action: "click->collapse#toggle"
              },
              class: "flex items-center justify-between w-full h-fit hover:cursor-pointer px-3"
            ) do
              if @form
                raw @form.label(@name, class: "text-lg font-semibold")
              else
                h2(class: "text-lg font-semibold", **@name_params) { @name }
              end
              heroicon(
                "chevron-down",
                variant: :solid,
                options: {
                  class: "w-8 h-8 text-red-500",
                  data_collapse_target: "collapseIcon"
                }
              )
            end
            div(class: "hidden", data: { collapse_target: "content" }) do
              div(class: "w-full") { div(data: @target_container) { yield if block_given? } }
            end
          end
        end
      end
    end
  end
end

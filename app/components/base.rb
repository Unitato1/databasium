# frozen_string_literal: true

module Databasium
  class Components::Base < Phlex::HTML
    # Include any helpers you want to be available across all components
    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::ClassNames
    include ::Databasium::HeroiconHelper

    if Rails.env.development?
      def before_template
        comment { "Before #{self.class.name}" }
        super
      end
    end

    protected

    def minimalistic_label_class
      "text-xs absolute -top-2.5 left-0"
    end

    def render_x_button(action: nil)
      button(type: "button", class: "text-red-500", data: { action: action }) do
        heroicon "x-mark", variant: :solid, options: { class: "w-8 h-8" }
      end
    end

    def render_collapsable(
      form: nil,
      name:,
      data_targets: {},
      name_params: {},
      class_name: nil,
      target_container: nil,
      &block
    )
      render Components::Databasium::Collapsable.new(
               name: name,
               form: form,
               data_targets: data_targets,
               name_params: name_params,
               class_name: class_name,
               target_container: target_container
             ) do
        yield if block_given?
      end
    end
  end
end

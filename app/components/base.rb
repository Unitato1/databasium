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
    def render_collapsable(form: nil, name:, data_targets:, class_name: nil, &block)
      render Components::Databasium::Collapsable.new(
               name: name,
               form: form,
               data_targets: data_targets,
               class_name: class_name
             ) do
        yield if block_given?
      end
    end
  end
end

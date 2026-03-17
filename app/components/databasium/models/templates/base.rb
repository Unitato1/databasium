module Components
  module Databasium
    class Models::Templates::Base < Components::Base
      protected

      def render_collapsable(name:, form:, name_params:, &block)
        render Components::Databasium::Collapsable.new(
                 name: name,
                 form: form,
                 name_params: name_params
               ) do
          yield if block_given?
        end
      end
    end
  end
end

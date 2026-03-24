module Components
  module Databasium
    class Models::Data < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize(model:)
        @model = model
      end

      def view_template
        h2(class: "text-lg font-semibold mb-2") { "Model Data" }
        form_with(method: :get, url: databasium.model_data_models_path) do |form|
          form.select :model, @model.keys, { include_blank: "Select a model" }
          form.submit "Get Model Data", class: "bg-accent shadow-accent rounded-xl p-1 px-4 py-2 mt-2"
        end
        pre(class: "bg-panel border-1 border-border rounded-xl p-4 overflow-y-auto") {
          JSON.pretty_generate(@model) }
      end
    end
  end
end

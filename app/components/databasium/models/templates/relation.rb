# <template data-model-target="relation">
#   <div class="flex gap-2 mt-2">
#     <select name="model[relations][][type]" class="border-2 rounded-xl p-1 border-gray-300 w-full mt-2">
#       <option value="belongs_to">Belongs To</option>
#       <option value="has_many">Has Many</option>
#       <option value="has_one">Has One</option>
#     </select>
#     <input type="text" name="model[relations][][table_name]" placeholder="Table name (e.g. user)" class="border-2 rounded-xl p-1 border-gray-300 w-full mt-2" />
#   </div>
# </template>

module Components
  module Databasium
    class Models::Templates::Relation < Models::Templates::Base
      def initialize
      end

      def view_template
        template(data: { model_target: "relation" }) do
          div(class: "flex gap-2 mt-2") do
            select(name: "model[relations][][type]", class: "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background focus:outline-none") do
              option(value: "belongs_to") { "Belongs To" }
              option(value: "has_many") { "Has Many" }
              option(value: "has_one") { "Has One" }
            end
            input(type: "text", name: "model[relations][][table_name]", placeholder: "Table name (e.g. user)",
              class: "border-2 rounded-xl p-1 border-border w-full mt-2 bg-background focus:outline-none")
          end
        end
      end
    end
  end
end

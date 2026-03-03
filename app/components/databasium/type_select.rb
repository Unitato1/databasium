# <select name="columns[][column_type]", class="border-2 rounded-xl p-1 border-gray-300 h-full">
# <option value="text">      Text      </option>
# <option value="string">    String    </option>
# <option value="integer">   Integer   </option>
# <option value="float">     Float     </option>
# <option value="decimal">   Decimal   </option>
# <option value="time">      Time      </option>
# <option value="date">      Date      </option>
# <option value="datetime">  Datetime  </option>
# <option value="timestamp"> Timestamp </option>
# <option value="binary">    Binary    </option>
# <option value="boolean">   Boolean   </option>
# <option value="references"> Reference   </option>
# </select>
# frozen_string_literal: true

module Components
  module Databasium
    class TypeSelect < Components::Base
      def initialize(name: nil)
        @name = name
      end

      def view_template
        select(name: @name, class: "border-2 rounded-xl p-1 border-gray-300 h-full") do
          option(value: "text") { "Text" }
          option(value: "string") { "String" }
          option(value: "integer") { "Integer" }
          option(value: "float") { "Float" }
          option(value: "decimal") { "Decimal" }
          option(value: "time") { "Time" }
          option(value: "date") { "Date" }
          option(value: "datetime") { "Datetime" }
          option(value: "timestamp") { "Timestamp" }
          option(value: "binary") { "Binary" }
          option(value: "boolean") { "Boolean" }
          option(value: "references") { "Reference" }
        end
      end
    end
  end
end

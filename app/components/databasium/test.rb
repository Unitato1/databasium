module Components
  module Databasium
    class Test < Phlex::HTML
      def initialize
      end

      def view_template
        h1 { "Hello, World!" }
      end
    end
  end
end

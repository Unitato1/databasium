# frozen_string_literal: true

module Components
  module Databasium
    class Migrations::MigrationStatus < Components::Base
        def initialize(status:, version:)
          @status = status
          @version = version
        end

        def view_template
          div(id: "migration_#{@version}_status") do
            div(class: "border-s-1 border-gray-300 ps-4") do
              if @status == "pending"
                span(class: "text-red-500") { "Pending" }
              else
                span(class: "text-green-500") { "Applied" }
              end
            end
          end
        end
    end
  end
end

# frozen_string_literal: true

module Views
  module Databasium
    class Errors::NonDevelopment < Views::Base
      include Phlex::Rails::Helpers::ContentFor

      def view_template
        content_for(:title) { "Non Development Environment" }
        div(class: "w-full h-full p-4") do
          h1(class: "text-2xl font-bold") do
            "You are not allowed to access this page in non development environment"
          end
          p(class: "text-red-500 bg-white w-fit px-4 py-2 rounded-md my-2") do
            "DATABASIUM IS NOT MEANT TO BE USED IN PRODUCTION, ALWAYS BE SURE TO NEVER EXPOSE IT TO THE PUBLIC."
          end
        end
      end
    end
  end
end

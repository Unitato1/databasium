# frozen_string_literal: true

module Views
  module Databasium
    class Homepage::Index < Views::Base
      include Phlex::Rails::Helpers::ContentFor

      def view_template
        content_for(:title) { "Homepage" }
        div(class: "w-full h-full p-4") do
          h1(class: "text-2xl font-bold") { "Hello world!" }
          section(class: "p-4 text-base text-gray-300 flex flex-col gap-1") do
            h2(class: "text-xl font-semibold") { "Welcome to Databasium" }
            p { "Databasium is a developer tool for managing your database." }
            p { "Its features are:" }
            ul(class: "list-disc list-inside") do
              li { "Create, read, update and delete(CRUD) data in your database." }
              li { "Generate models and migrations for your database." }
              li { "Generate schema for your database." }
            end
            p(class: "text-red-500 bg-white w-fit px-4 py-2 rounded-md my-2") do
              "DATABASIUM IS NOT MEANT TO BE USED IN PRODUCTION, ALWAYS BE SURE TO NEVER EXPOSE IT TO THE PUBLIC."
            end
          end
        end
      end
    end
  end
end

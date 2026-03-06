# <div class="flex p-4 px-12 border-b-1 border-b-gray-300 mb-4 shadow-md">
#   <div class="flex-1">
#     <h1 class="text-5xl"><%= content_for?(:title) ? yield(:title) : "Databasium" %></h1>
#   </div>
#   <div class="flex-1 flex justify-end align-end text-3xl">
#     <div class="flex gap-4">
#       <%= link_to "Records", records_path, class: "text-blue-400 font-size-lg underline" %>
#       <%= link_to "Migrations", migrations_path, class: "text-blue-400 font-size-lg underline" %>
#       <%= link_to "Models", new_model_path, class: "text-blue-400 font-size-lg underline" %>
#       <%= link_to "Schema", schemas_path, class: "text-blue-400 font-size-lg underline" %>
#       <%= link_to "Edits", new_migration_path, class: "text-blue-400 font-size-lg underline" %>
#     </div>
#   </div>
# </div>
# frozen_string_literal: true

module Components
  module Databasium
    class Global::Header < Components::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Routes
      PAGES = [
        {
          path: :records_path,
          text: "Records"
        },
        {
          path: :migrations_path,
          text: "Migrations"
        },
        {
          path: :new_model_path,
          text: "Models"
        },
        {
          path: :schemas_path,
          text: "Schema"
        },
        {
          path: :new_migration_path,
          text: "Edits"
        }
      ]

      def initialize(title: nil)
        @title = title
      end

      def view_template
        div(class: "flex p-4 px-12 border-b-1 bg-blue-100 border-b-blue-500 mb-4 shadow-md") do
          render_title
          render_navigation_links
        end
      end

      private

      def render_title
        div(class: "flex-1") do
          h1(class: "text-5xl text-blue-900") do
            @title || "Databasium"
          end
        end
      end

      def render_navigation_links
        nav(class: "flex-1 flex justify-end items-center text-2xl gap-4") do
          PAGES.each do |page|
            link_to page[:text], helpers.send(page[:path]), class: "text-blue-900 not-last:border-e-1 border-blue-500 pe-4"
          end
        end
      end
    end
  end
end

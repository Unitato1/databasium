module Views
  module Layouts
    class Databasium::Application < Views::Base
      include Phlex::Rails::Layout
      include Phlex::Rails::Helpers::ContentFor
      include Phlex::Rails::Helpers::StylesheetLinkTag
      include Phlex::Rails::Helpers::JavascriptImportmapTags
      def view_template(&block)
        doctype

        html do
          head do
            title { content_for?(:title) ? yield(:title) : "Databasium" }
            meta charset: "utf-8"
            csrf_meta_tags
            csp_meta_tag
            yield :head
            stylesheet_link_tag "databasium", "data-turbo-track": Rails.env.production? ? "reload" : ""
            javascript_importmap_tags "databasium/application"
          end
          body(class: "flex h-dvh bg-background text-main-text scrollbar-thin", data: { controller: "layout" }) do
            render Components::Databasium::Global::Sidebar.new(sidebar: content_for(:sidebar))
            div(class: "flex-1 overflow-hidden flex flex-col max-h-full border-2 border-red m-2", data: { controller: "hide" }) do
              render Components::Databasium::Global::HeaderActions.new(actions: content_for(:header_actions))
              yield block_given? ? block : block.call
            end
          end
        end
      end
    end
  end
end

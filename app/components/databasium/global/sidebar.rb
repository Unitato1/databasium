class Components::Databasium::Global::Sidebar < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::CurrentPage
  PAGES = [
    { icon: "list-bullet", path: :records_path, text: "Records" },
    { icon: "arrow-path", path: :migrations_path, text: "Migrations" },
    { icon: "cube", path: :new_model_path, text: "Models" },
    { icon: "table-cells", path: :schemas_path, text: "Schema" },
    { icon: "pencil-square", path: :new_migration_path, text: "Edits" }
  ].freeze

  def initialize(sidebar: nil)
    @sidebar = sidebar
  end

  def view_template
    div(
      class: "flex flex-col bg-panel border-r-2 border-r-border py-2 px-3 w-80",
      data: {
        layout_target: "sidebar"
      }
    ) do
      div(class: "flex flex-col gap-2 pb-6") do
        PAGES.each do |page|
          path = databasium.send(page[:path])
          link_to(
            path,
            class:
              class_names(
                "text-main-text hover:text-hover flex items-center gap-2 py-2 px-3 border border-border rounded-lg",
                "bg-accent shadow-accent" => current_page?(path)
              )
          ) do
            raw helpers.heroicon(page[:icon], variant: :outline, options: { class: "w-6 h-6" })
            span(class: "ml-2") { page[:text] }
          end
        end
      end
      raw @sidebar
    end
  end
end

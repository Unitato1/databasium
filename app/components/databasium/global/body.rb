class Components::Databasium::Global::Body < Components::Base
  include Phlex::Rails::Helpers::ContentFor
  def initialize(flash: nil, &block)
    @block = block
    @flash = flash
  end

  def view_template
    body(class: "flex flex-col overflow-x-hidden") do
      render Components::Databasium::Global::Sidebar.new
      render Components::Databasium::Global::Header.new(
               title: content_for?(:title) ? yield(:title) : "Databasium"
             )
      render Components::Databasium::Global::Flash.new(
               success: @flash[:success],
               error: @flash[:error]
             )
      yield @block
    end
  end
end

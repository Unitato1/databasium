class Databasium::HomepageController < Databasium::ApplicationController
  def index
    render Views::Databasium::Homepage::Index.new
  end
end

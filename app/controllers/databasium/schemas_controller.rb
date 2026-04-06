class Databasium::SchemasController < Databasium::ApplicationController
  include Pagy::Method

  def index
    if params[:model].present?
      # @schema = { params[:model].downcase.pluralize => Databasium::Schema.new.get_model_associations(params[:model]) }
      @schema = Databasium::Schema.new.get_model_associations(params[:model])
    else
      @schema = Databasium::Schema.new.schema
    end
    @models = Databasium::Models.new.get_all_models_from_dir(search: params[:search])
    @pagy, @models = pagy(@models, limit: 10, root_key: "models")
    puts (params[:model])
    render Views::Databasium::Schemas::Index.new(schema: @schema, models: @models, pagy: @pagy)
  end
end

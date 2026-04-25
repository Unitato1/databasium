class Databasium::SchemasController < Databasium::ApplicationController
  include Pagy::Method

  def index
    @layers = params[:layers].nil? ? nil : params[:layers].presence.try(:to_i) || 1
    @model = params[:model]
    if params[:model].present?
      @schema = Databasium::Schema.new.get_model_and_layers_BFS(params[:model], @layers)
    else
      @schema = Databasium::Schema.new.schema
    end

    models, pagy = get_models

    respond_to do |format|
      format.html do
        render Views::Databasium::Schemas::Index.new(
                 schema: @schema,
                 models: models,
                 pagy: pagy,
                 model: @model,
                 layers: @layers
               )
      end
      format.json { render json: @schema }
    end
  end

  def sidebar
    models, pagy = get_models

    render Components::Databasium::Schemas::Sidebar.new(models: models, pagy: pagy)
  end

  private

  def get_models
    @models = Databasium::Models.new.get_all_models_from_dir(search: params[:search])
    @pagy, @models = pagy(@models, limit: 10, root_key: "models")
    [@models, @pagy]
  end
end

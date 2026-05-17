class Databasium::SchemasController < Databasium::ApplicationController
  include Pagy::Method
  before_action :create_schema_service, except: [ :sidebar ]

  def index
    layers = params[:layers].nil? ? nil : params[:layers].presence.try(:to_i) || 1
    model = params[:model]
    if params[:model].present?
      schema = @schema_service.get_model_and_layers_BFS(model, layers)
    else
      schema = @schema_service.schema
    end

    models, pagy = get_models

    respond_to do |format|
      format.html do
        render Views::Databasium::Schemas::Index.new(
                 schema: schema,
                 models: models,
                 pagy: pagy,
                 model: model,
                 layers: layers
               )
      end
      format.json { render json: @schema }
    end
  end

  def sidebar
    models, pagy = get_models

    render Components::Databasium::SearchResults::SchemaModels.new(models: models, pagy: pagy)
  end

  def sync_schema
    @schema_service.sync!
    redirect_back fallback_location: schemas_path
  end

  private

  def create_schema_service
    @schema_service = Databasium::Schema.new
  end

  def get_models
    raw_models = Databasium::Model.new.get_all_models_from_db(search: params[:search])
    pagy, models = pagy(raw_models, limit: 7, root_key: "models")
    [ models, pagy ]
  end
end

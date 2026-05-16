class Databasium::ModelsController < Databasium::ApplicationController
  include Pagy::Method
  before_action :create_model_service
  MODEL_TEMPLATE_PATH = Databasium::Engine.root.join("lib/databasium/templates/model.rb.tt")

  def new
    @models = @model_service.get_all_models_from_db(search: params[:search])
    @pagy, @models = pagy(@models, limit: 7, root_key: "models")

    render Views::Databasium::Models::New.new(content: nil, models: @models, pagy: @pagy)
  end

  def get_model
    @content = @model_service.read_model_file(params[:model])
    @attributes = @model_service.get_model_data_from_file(params[:model])
    @model = params[:model]
    @models = @model_service.get_all_models_from_db(search: params[:search])
    @pagy, @models = pagy(@models, limit: 7, root_key: "models")

    respond_to do |format|
      format.html do
        render Views::Databasium::Models::New.new(
                 content: @content,
                 model: @model,
                 attributes: @attributes,
               )
      end
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.replace(
                   "model_preview",
                   Components::Databasium::Models::ModelPreview.new(content: @content)
                 )
      end
    end
  end

  def sidebar
    @models = @model_service.get_all_models_from_db(search: params[:search])
    @pagy, @models = pagy(@models, limit: 7, root_key: "models")

    render Components::Databasium::Models::Sidebar.new(models: @models, pagy: @pagy)
  end

  def create
    content = generate_model_content
    if params[:commit] == "Create model file"
      write_file(content)
      redirect_to schemas_path, notice: "Model file created successfully"
    else
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.replace(
                     "model_preview",
                     Components::Databasium::Models::ModelPreview.new(content: content)
                   )
        end
      end
    end
  end

  private

  def create_model_service
    @model_service = Databasium::Model.new
  end

  def generate_model_content
    renderer = ERB.new(File.read(MODEL_TEMPLATE_PATH), trim_mode: "-")

    context =
      @model_service.create_model_data(
        model_name: model_params[:model_name],
        attributes: model_params[:attributes],
        relations: model_params[:relations],
        unknown: model_params[:unknown]
      )

    renderer.result(context.get_binding)
  end

  def write_file(content)
    model_name = model_params[:model_name].underscore
    destination_path = Rails.root.join("app/models/#{model_name}.rb")
    File.open(destination_path, "w") { |file| file.write(content) }
  end

  def model_params
    params.require(:model).permit(
      :model_name,
      attributes: [ :name, :type, validations: %i[name type value] ],
      relations: %i[type table_name],
      unknown: []
    )
  end
end

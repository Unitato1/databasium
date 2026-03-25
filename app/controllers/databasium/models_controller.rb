class Databasium::ModelsController < Databasium::ApplicationController
  include Pagy::Method

  def new
    @models = Databasium::Models.new.get_all_models_from_dir(search: params[:search])
    @pagy, @models = pagy(@models, limit: 10, root_key: "models")

    render Views::Databasium::Models::New.new(content: nil, models: @models, pagy: @pagy)
  end

  def get_model
    @content = File.read(Rails.root.join("app/models/#{params[:model].downcase}.rb"))
    @attributes = Databasium::Models.new.get_model_data_from_file(params[:model].upcase_first)
    @model = params[:model] if params[:model]
    @models = Databasium::Models.new.get_all_models_from_dir(search: params[:search])
    respond_to do |format|
      format.html do
        render Views::Databasium::Models::New.new(
                 content: @content,
                 model: @model,
                 attributes: @attributes,
                 models: @models,
                 pagy: @pagy
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

  def create
    @content = generate_model_content
    if params[:commit] == "Create model file"
      write_file(@content)
      redirect_to schemas_path, notice: "Model file created successfully"
    else
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.replace(
                     "model_preview",
                     Components::Databasium::Models::ModelPreview.new(content: @content)
                   )
        end
      end
    end
  end

  private

  def generate_model_content
    template_path = Databasium::Engine.root.join("lib/databasium/templates/model.rb.tt")

    renderer = ERB.new(File.read(template_path), trim_mode: "-")

    context =
      Databasium::Model.new(
        model_name: model_params[:model_name],
        attributes: model_params[:attributes],
        relations: model_params[:relations]
      )

    renderer.result(context.get_binding)
  end

  def write_file(content)
    model_name = model_params[:model_name].downcase
    destination_path = Rails.root.join("app/models/#{model_name}.rb")
    File.open(destination_path, "w") { |file| file.write(content) }
  end

  def model_params
    params.require(:model).permit(
      :model_name,
      attributes: [:name, :type, validations: %i[name type value]],
      relations: %i[type table_name]
    )
  end
end

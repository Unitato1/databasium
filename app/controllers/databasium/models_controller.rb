class Databasium::ModelsController < Databasium::ApplicationController
  def new
    @model = Databasium::Model.new(model_name: params[:model_name], attributes: params[:attributes])
  end

  def create
    @content = generate_model_content
    if params[:commit] == "Create model file"
      write_file(@content)
      redirect_to schemas_path, notice: "Model file created successfully"
    else
      respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace("model_preview", partial: "databasium/models/components/model_preview", locals: { content: @content }) }
      end
    end
  end

  private

  def generate_model_content
    template_path = Databasium::Engine.root.join("lib/databasium/templates/model.rb.tt")

    renderer = ERB.new(File.read(template_path), trim_mode: "-")

    context = Databasium::Model.new(
      model_name: model_params[:model_name],
      attributes: model_params[:attributes],
    )

    renderer.result(context.get_binding)
  end

  def write_file(content)
    model_name = model_params[:model_name].downcase
    destination_path = Rails.root.join("app/models/#{model_name}.rb")
    File.open(destination_path, "w") { |file| file.write(content) }
  end

  def model_params
    params.require(:model)
      .permit(
      :model_name,
      attributes: [
        :name,
        :type,
        validations: [
          :name,
          :type,
          :value
        ]
      ]
    )
  end
end

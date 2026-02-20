class Databasium::ModelsController < Databasium::ApplicationController
  def index
    template_path = Databasium::Engine.root.join("lib/databasium/templates/model.rb.tt")

    renderer = ERB.new(File.read(template_path), trim_mode: "-")

    context = Databasium::Model.new(
      model_name: "User",
      attributes: [
        { name: "name",      type: "string", validations: [ { name: "name", type: "presence", value: true } ] },
        { name: "email",     type: "string", validations: [ { name: "age", type: "presence", value: true }, { name: "email", type: "uniqueness", value: true } ] },
        { name: "password",  type: "string", validations: [ { name: "password", type: "presence", value: true } ] },
        { name: "created_at", type: "datetime", validations: [ { name: "created_at", type: "presence", value: true } ] },
        { name: "updated_at", type: "datetime", validations: [ { name: "updated_at", type: "presence", value: true } ] }
      ],
    )
    destination_path = Rails.root.join("app/models/user.rb")
    content = renderer.result(context.get_binding)
    File.open(destination_path, "w") { |file| file.write(content) }
    @content = content
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace("migration_preview", partial: "databasium/migrations/components/migration_preview", locals: { content: @content }) }
    end
  end

  def new
    @model = Databasium::Model.new(model_name: params[:model_name], attributes: params[:attributes])
  end

  def create
    # @model = Databasium::Model.new(model_name: params[:model_name], attributes: params[:attributes])
    # redirect_to models_path
    @content = generate_model_content
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace("model_preview", partial: "databasium/models/components/model_preview", locals: { content: @content }) }
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
    puts params.inspect

    renderer.result(context.get_binding)
  end

  def write_file(content, path)
    destination_path = Rails.root.join("app/models/user.rb")
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

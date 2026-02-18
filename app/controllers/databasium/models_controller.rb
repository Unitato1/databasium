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
    @content_json = content.to_json
    @content = content
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace("migration_preview", partial: "databasium/migrations/components/migration_preview", locals: { content: @content }) }
    end
  end
end

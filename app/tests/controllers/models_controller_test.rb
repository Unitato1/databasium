require "test_helper"

class Databasium::ModelsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @model_name = "TestModelFromControllerTest"
    @destination_path = Rails.root.join("app/models/#{@model_name.downcase}.rb")
    FileUtils.rm_f(@destination_path)
  end

  def teardown
    FileUtils.rm_f(@destination_path)
  end

  test "GET /databasium/models/new is successful" do
    get "/databasium/models/new"

    assert_response :success
  end

  test "POST /databasium/models renders turbo stream preview" do
    post "/databasium/models",
         params: {
           model: {
             model_name: "User",
             attributes: [{ name: "email", type: "string", validations: [] }],
             relations: []
           }
         },
         as: :turbo_stream

    assert_response :success
    assert_equal Mime[:turbo_stream].to_s, response.media_type
    assert_includes response.body, 'target="model_preview"'
  end

  test "POST /databasium/models with commit creates model file and redirects" do
    post "/databasium/models",
         params: {
           commit: "Create model file",
           model: {
             model_name: @model_name,
             attributes: [],
             relations: []
           }
         }

    assert_redirected_to "/databasium/schemas"
    assert_equal "Model file created successfully", flash[:notice]
    assert File.exist?(@destination_path)
    assert_includes File.read(@destination_path),
                    "class Testmodelfromcontrollertest < ApplicationRecord"
  end
end

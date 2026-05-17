# frozen_string_literal: true

require "test_helper"

class Databasium::SchemasControllerTest < ActionDispatch::IntegrationTest
  test "GET /databasium/schemas is successful" do
    get "/databasium/schemas"

    assert_response :success
  end
end

# frozen_string_literal: true

require "test_helper"

class Databasium::RecordsControllerTest < ActionDispatch::IntegrationTest
  test "GET records index" do
    get "/databasium/records"

    assert_response :success
  end
end

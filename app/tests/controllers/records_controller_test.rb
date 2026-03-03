require "test_helper"

class Databasium::RecordsControllerTest < ActionDispatch::IntegrationTest
  def setup
  end

  test "GET records index" do
    get "/databasium/records"

    assert_response :success
  end
end

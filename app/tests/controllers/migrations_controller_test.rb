require "test_helper"

class Databasium::MigrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
  end
  test "GET migrations index" do
    get "/databasium/migrations"

    assert_response :success
  end

  test "GET migrations new" do
    get "/databasium/migrations/new"

    assert_response :success
  end

  test "POST migrations create" do
    post "/databasium/migrations",
         params: {
           table_name: "users",
           add_migration: "Generate Preview",
           migration_action: "create",
           add_model: "1",
           columns: [ { column_name: "name", column_type: "string" } ],
           validation: [ { column_name: "name", type: "not_null" } ]
         },
         as: :turbo_stream
    assert_response :success
    assert_equal Mime[:turbo_stream].to_s, response.media_type
    assert_includes response.body, 'target="migration_preview"'
  end
end

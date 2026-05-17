# frozen_string_literal: true

require "test_helper"

class Databasium::SchemaTest < ActiveSupport::TestCase
  test "can be instantiated" do
    schema = Databasium::Schema.new

    assert_not_nil schema
    assert_kind_of Array, schema.tables
  end
end

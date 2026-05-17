# frozen_string_literal: true

require "test_helper"

class Databasium::ModelTest < ActiveSupport::TestCase
  test "can be instantiated" do
    assert_not_nil Databasium::Model.new
  end

  test "returns models from database" do
    models = Databasium::Model.new.get_all_models_from_db

    assert_kind_of Array, models
  end
end

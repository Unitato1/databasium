# frozen_string_literal: true

require "test_helper"

class Databasium::RecordTest < ActiveSupport::TestCase
  test "can be instantiated without a model" do
    assert_not_nil Databasium::Record.new
  end
end

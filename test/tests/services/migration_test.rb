# frozen_string_literal: true

require "test_helper"

class Databasium::MigrationTest < ActiveSupport::TestCase
  test "can be instantiated" do
    assert_not_nil Databasium::Migration.new
  end

  test "returns migrations list" do
    migrations = Databasium::Migration.new.get_migrations(nil)

    assert_kind_of Array, migrations
  end
end

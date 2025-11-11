# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_11_194832) do
  create_table "cars", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "name"
    t.datetime "updated_at", null: false
  end

  create_table "faculties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.integer "number"
    t.string "street"
    t.datetime "updated_at", null: false
  end

  create_table "newdatatables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "engine"
    t.string "name"
    t.datetime "updated_at", null: false
    t.decimal "version"
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "likes"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.integer "location_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_schools_on_location_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.integer "credits"
    t.string "name"
    t.integer "school_id", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_students_on_school_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "schools", "locations"
  add_foreign_key "students", "schools"
end

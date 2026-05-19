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

ActiveRecord::Schema[8.1].define(version: 2026_05_19_140007) do
  create_table "blog_author_profiles", force: :cascade do |t|
    t.text "bio"
    t.integer "blog_author_id", null: false
    t.datetime "created_at", null: false
    t.string "location", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.index [ "blog_author_id" ], name: "index_blog_author_profiles_on_blog_author_id"
  end

  create_table "blog_authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "editor", default: false, null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index [ "email" ], name: "index_blog_authors_on_email", unique: true
  end

  create_table "blog_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index [ "slug" ], name: "index_blog_categories_on_slug", unique: true
  end

  create_table "blog_comments", force: :cascade do |t|
    t.boolean "approved", default: true, null: false
    t.integer "blog_author_id", null: false
    t.integer "blog_post_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "blog_author_id" ], name: "index_blog_comments_on_blog_author_id"
    t.index [ "blog_post_id" ], name: "index_blog_comments_on_blog_post_id"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.integer "blog_author_id", null: false
    t.integer "blog_category_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.boolean "published", default: false, null: false
    t.datetime "published_at"
    t.string "slug", null: false
    t.text "test"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "views_count", default: 0, null: false
    t.index [ "blog_author_id" ], name: "index_blog_posts_on_blog_author_id"
    t.index [ "blog_category_id" ], name: "index_blog_posts_on_blog_category_id"
    t.index [ "slug" ], name: "index_blog_posts_on_slug", unique: true
    t.index [ "test" ], name: "index_blog_posts_on_test", unique: true
  end

  create_table "blog_taggings", force: :cascade do |t|
    t.integer "blog_post_id", null: false
    t.integer "blog_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "blog_post_id", "blog_tag_id" ], name: "index_blog_taggings_on_blog_post_id_and_blog_tag_id", unique: true
    t.index [ "blog_post_id" ], name: "index_blog_taggings_on_blog_post_id"
    t.index [ "blog_tag_id" ], name: "index_blog_taggings_on_blog_tag_id"
  end

  create_table "blog_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index [ "slug" ], name: "index_blog_tags_on_slug", unique: true
  end

  add_foreign_key "blog_author_profiles", "blog_authors"
  add_foreign_key "blog_comments", "blog_authors"
  add_foreign_key "blog_comments", "blog_posts"
  add_foreign_key "blog_posts", "blog_authors"
  add_foreign_key "blog_posts", "blog_categories"
  add_foreign_key "blog_taggings", "blog_posts"
  add_foreign_key "blog_taggings", "blog_tags"
end

class CreateBlogPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_posts do |t|
      t.references :blog_author, null: false, foreign_key: true
      t.references :blog_category, null: false, foreign_key: true
      t.text :body, null: false
      t.boolean :published, default: false, null: false
      t.datetime :published_at
      t.string :slug, null: false
      t.text :test
      t.string :title, null: false
      t.integer :views_count, default: 0, null: false
      t.timestamps
    end

    add_index :blog_posts, :slug, unique: true
    add_index :blog_posts, :test, unique: true
  end
end

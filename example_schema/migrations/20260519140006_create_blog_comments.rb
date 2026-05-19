class CreateBlogComments < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_comments do |t|
      t.boolean :approved, default: true, null: false
      t.references :blog_author, null: false, foreign_key: true
      t.references :blog_post, null: false, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
  end
end

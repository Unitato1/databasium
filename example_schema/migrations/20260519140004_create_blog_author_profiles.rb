class CreateBlogAuthorProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_author_profiles do |t|
      t.text :bio
      t.references :blog_author, null: false, foreign_key: true
      t.string :location, null: false
      t.string :website
      t.timestamps
    end
  end
end

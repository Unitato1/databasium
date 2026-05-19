class CreateBlogTags < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_tags do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end

    add_index :blog_tags, :slug, unique: true
  end
end

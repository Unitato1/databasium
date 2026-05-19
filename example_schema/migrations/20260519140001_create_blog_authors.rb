class CreateBlogAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_authors do |t|
      t.boolean :editor, default: false, null: false
      t.string :email, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :blog_authors, :email, unique: true
  end
end

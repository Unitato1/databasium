class CreateNewdatatables < ActiveRecord::Migration[8.1]
  def change
    create_table :newdatatables do |t|
      t.string :name
      t.integer :engine
      t.decimal :version

      t.timestamps
    end
  end
end

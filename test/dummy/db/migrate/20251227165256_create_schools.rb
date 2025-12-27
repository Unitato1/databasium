class CreateSchools < ActiveRecord::Migration[8.1]
  def change
    create_table :schools do |t|
      t.text :name, null: false
      t.integer :capacity, null: false

      t.timestamps
    end
  end
end

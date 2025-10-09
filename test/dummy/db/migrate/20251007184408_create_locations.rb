class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :street
      t.string :city
      t.integer :number

      t.timestamps
    end
  end
end

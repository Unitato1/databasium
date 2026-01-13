class CreateCars < ActiveRecord::Migration[8.1]
  def change
    create_table :cars do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end

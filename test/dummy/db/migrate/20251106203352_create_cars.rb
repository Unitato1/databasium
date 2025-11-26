class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.date :name

      t.timestamps
    end
  end
end

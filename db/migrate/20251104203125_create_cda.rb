class CreateCda < ActiveRecord::Migration[8.0]
  def change
    create_table :cdas do |t|
      t.string :name

      t.timestamps
    end
  end
end

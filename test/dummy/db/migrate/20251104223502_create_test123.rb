class CreateTest123 < ActiveRecord::Migration[8.0]
  def change
    create_table :test123s do |t|
      t.string :name

      t.timestamps
    end
  end
end

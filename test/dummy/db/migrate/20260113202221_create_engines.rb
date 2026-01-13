class CreateEngines < ActiveRecord::Migration[8.1]
  def change
    create_table :engines do |t|
      t.text :name

      t.timestamps
    end
  end
end

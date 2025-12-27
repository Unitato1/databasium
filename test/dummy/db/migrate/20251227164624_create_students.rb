class CreateStudents < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |t|
      t.text :name, null: false
      t.integer :height , null: false
      t.integer :age, null: false

      t.timestamps
    end
  end
end

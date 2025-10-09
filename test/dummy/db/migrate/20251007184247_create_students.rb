class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :name
      t.integer :age
      t.integer :credits

      t.timestamps
    end
  end
end

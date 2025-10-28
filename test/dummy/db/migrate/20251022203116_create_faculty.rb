class CreateFaculty < ActiveRecord::Migration[8.0]
  def change
    create_table :faculties do |t|
      t.string :name

      t.timestamps
    end
  end
end

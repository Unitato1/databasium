class CreateAbc < ActiveRecord::Migration[8.0]
  def change
    create_table :abcs do |t|
      t.timestamps
    end
  end
end

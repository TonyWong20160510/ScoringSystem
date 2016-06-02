class CreateMasters < ActiveRecord::Migration
  def change
    create_table :masters do |t|
      t.string :name
      t.integer :department_id

      t.timestamps
    end
  end
end

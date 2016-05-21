class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :password_digest
      t.integer :mobile
      t.integer :department_id
      t.string :type

      t.timestamps
    end
  end
end

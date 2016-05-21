class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.integer :master_id
      t.integer :employee_id
      t.integer :department_id
      t.string :term_phase
      t.string :master_score
      t.string :department_score
      t.timestamps
    end
  end
end

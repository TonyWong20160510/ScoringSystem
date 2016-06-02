class CreateDepartmentTerms < ActiveRecord::Migration
  def change
    create_table :department_terms do |t|
      t.string :phase
      t.string :department_id
      t.string :integer
      t.integer :department_score

      t.timestamps
    end
  end
end

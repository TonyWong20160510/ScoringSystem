class AddDempartmentScoreToMarks < ActiveRecord::Migration
  def change
    add_column :marks, :department_score, :integer
  end
end

class CreateMasterTerms < ActiveRecord::Migration
  def change
    create_table :master_terms do |t|
      t.string :phase
      t.integer :master_id
      t.integer :master_score

      t.timestamps
    end
  end
end

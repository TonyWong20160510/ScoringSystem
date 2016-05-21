class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :name
      t.string :password
      t.string :password_digest
      t.integer :mobile

      t.timestamps
    end
  end
end

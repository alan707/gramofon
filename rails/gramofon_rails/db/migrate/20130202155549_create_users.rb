class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.integer :facebook_id
      t.string :username

      t.timestamps
    end
  end
end

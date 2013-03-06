class RemoveFacebookUsernameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :facebook_username
  end

  def down
    add_column :users, :facebook_username, :string
  end
end

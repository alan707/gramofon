class AddFacebookUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_username, :string
    add_column :audio_clips, :play_count, :integer
    add_column :audio_clips, :like_count, :integer
  end
end

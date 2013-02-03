class AddUsernameToAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :username, :string
  end
end

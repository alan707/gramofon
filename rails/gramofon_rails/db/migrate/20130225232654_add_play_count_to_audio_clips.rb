class AddPlayCountToAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :play_count, :integer, :null => false, :default => 0
    add_column :audio_clips, :like_count, :integer, :null => false, :default => 0
  end
end

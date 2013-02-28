class RemovePlayCountFromAudioClips < ActiveRecord::Migration
  def up
    remove_column :audio_clips, :play_count
    remove_column :audio_clips, :like_count
  end

  def down
    add_column :audio_clips, :like_count, :integer
    add_column :audio_clips, :play_count, :integer
  end
end

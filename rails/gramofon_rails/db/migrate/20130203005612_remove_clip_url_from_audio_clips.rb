class RemoveClipUrlFromAudioClips < ActiveRecord::Migration
  def up
    remove_column :audio_clips, :clip_url
    remove_column :audio_clips, :latitude
    remove_column :audio_clips, :longitude
  end

  def down
    add_column :audio_clips, :longitude, :integer
    add_column :audio_clips, :latitude, :integer
    add_column :audio_clips, :clip_url, :string
  end
end

class AddSoundFileUrlToAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :sound_file_url, :string
  end
end

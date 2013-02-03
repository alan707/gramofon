class AddSoundFileToAudioClip < ActiveRecord::Migration
  def change
    add_column :audio_clips, :sound_file, :string
  end
end

class AddFsVenueToAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :fsvenue, :string
  end
end

class AddAddressToAudioClips < ActiveRecord::Migration
  def change
    add_column :audio_clips, :address, :string
  end
end

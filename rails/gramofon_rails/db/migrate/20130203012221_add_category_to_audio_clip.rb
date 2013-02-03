class AddCategoryToAudioClip < ActiveRecord::Migration
  def change
    add_column :audio_clips, :category, :string
  end
end

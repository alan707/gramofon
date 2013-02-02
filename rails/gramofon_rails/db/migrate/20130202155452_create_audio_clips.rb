class CreateAudioClips < ActiveRecord::Migration
  def change
    create_table :audio_clips do |t|
      t.string :clip_url
      t.integer :user_id
      t.integer :latitude
      t.integer :longitude
      t.string :title
      t.boolean :public

      t.timestamps
    end
  end
end

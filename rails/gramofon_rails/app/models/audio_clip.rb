class AudioClip < ActiveRecord::Base
belongs_to :user

mount_uploader :sound_file, SoundFileUploader


  attr_accessible :clip_url, :latitude, :longitude, :public, :title, :user_id, :username, :sound_file, :sound_file_cache
end

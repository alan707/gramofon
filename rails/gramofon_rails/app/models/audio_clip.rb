class AudioClip < ActiveRecord::Base
  attr_accessible :clip_url, :latitude, :longitude, :public, :title, :user_id
end

class AudioClip < ActiveRecord::Base
belongs_to :user



validates :like_count, :play_count, :numericality => { :greater_than_or_equal_to => 0 }




mount_uploader :sound_file, SoundFileUploader




  attr_accessible :latitude, :longitude, :public, :title, :user_id, :username, :sound_file, :sound_file_cache, :fsvenue, :like_count, :play_count,
  :sound_file_url

  def as_json(options={})
    {:id 			   => self.id,
     :created_at       => self.created_at,
     :updated_at		=> self.updated_at,
     :latitude        	=> self.latitude,
     :longitude        => self.longitude,
     :title  	    	=> self.title,
     :user_id          => self.user_id,
     :sound_file        => self.sound_file,
     :fsvenue			=> self.fsvenue,
     :like_count		=> self.like_count,
     :play_count		=> self.play_count,
     :sound_file_url	=> self.sound_file_url,
     :user 				=> self.user
           }
  end

end

class User < ActiveRecord::Base
	has_many :audio_clips

  attr_accessible :email, :facebook_id, :firstname, :lastname, :username, :facebook_username, :photo_url
  
  def to_param
    username
  end

  def as_json(options={})
    {:id                 => self.id,
     :email 	           => self.email,
     :facebook_id        => self.try(:facebook_id),
     :firstname          => self.firstname,
     :lastname  	 	     => self.lastname,
     :username            => self.username,
     :facebook_username   => self.try(:facebook_username),
     :photo_url			      => self.try(:photo_url)
        }
  end


end

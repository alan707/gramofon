class User < ActiveRecord::Base
	has_many :audio_clips

  attr_accessible :email, :facebook_id, :firstname, :lastname, :username, :photo_url
  
  
  # unless self.username.blank?
    def to_param
      if self.username.blank?
      "#{id}"
      else
      "#{username}"
    end
    end
  # end

  def as_json(options={})
    {:id                 => self.id,
     :email 	           => self.email,
     :facebook_id        => self.try(:facebook_id),
     :firstname          => self.firstname,
     :lastname  	 	     => self.lastname,
     :username            => self.username,
     :photo_url			      => self.try(:photo_url)
        }
  end


end

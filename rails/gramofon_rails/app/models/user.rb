class User < ActiveRecord::Base
	has_many :audio_clips

  attr_accessible :email, :facebook_id, :firstname, :lastname, :username
  
  def to_param
    username
  end

end

class User < ActiveRecord::Base
  attr_accessible :email, :facebook_id, :firstname, :lastname, :username
end

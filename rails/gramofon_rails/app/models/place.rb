class Place < ActiveRecord::Base
 attr_accessible :title, :body

reverse_geocoded_by :latitude, :longitude,
  :address => :location
after_validation :reverse_geocode

end

class StorageSpace < ActiveRecord::Base
  belongs_to :user
  acts_as_taggable
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :process_geocoding => :geocode?,
                  :address => "address", :normalized_address => "address",
                  :msg => "Sorry, not even Google could figure out where that is"

  def geocode?
    (!address.blank? && (lat.blank? || lng.blank?)) || address_changed?
  end
  
end

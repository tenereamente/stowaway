class Space < ActiveRecord::Base
  belongs_to :user
  acts_as_taggable
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :process_geocoding => :geocode?,
                  :normalized_address => "normalized_address",
                  :msg => "Sorry, not even Google could figure out where that is"

  has_attached_file :photo, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  def gmaps4rails_address
    "#{self.address1}, #{self.city}, #{self.zip}"
  end

  def geocode?
    (!normalized_address.blank? && (lat.blank? || lng.blank?)) || address1_changed? || address2_changed? || city_changed? || zip_changed?
  end
end

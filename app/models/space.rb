class Space < ActiveRecord::Base
  belongs_to :user
  has_many :listings
  acts_as_taggable
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :process_geocoding => :geocode?,
                  :normalized_address => "normalized_address",
                  :msg => "Sorry, not even Google could figure out where that is"

  [:photo, :photo1, :photo2, :photo3, :photo4, :photo5].each do |p|
    has_attached_file p, styles: { thumb: '100x100>', square: '200x200#', medium: '300x300>' }
  end


  scope :owned, -> { where('user_id is not null')}

  scope :by_user, lambda { |id|
    where(:user_id => id)
  }

  def gmaps4rails_address
    "#{self.address1}, #{self.city}, #{self.state} #{self.zip}"
  end

  def geocode?
    (!normalized_address.blank? && (lat.blank? || lng.blank?)) || address1_changed? || address2_changed? || city_changed? || zip_changed?
  end
end

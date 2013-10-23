class Space < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :user
  has_many :listings
  acts_as_taggable
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :process_geocoding => :geocode?,
                  :normalized_address => "normalized_address",
                  :msg => "Sorry, not even Google could figure out where that is"

  has_paper_trail

  [:photo, :photo1, :photo2, :photo3, :photo4, :photo5].each do |p|
    has_attached_file p, styles: { thumb: '100x100>', square: '200x200#', medium: '300x300>' }, :s3_protocol => :https
  end

  has_many :space_rentals
  has_many :renters, :source => :user, :through => :space_rentals


  scope :owned, -> { where('user_id is not null')}
  scope :available, -> { where('available is true')}
  scope :complete, -> { where('complete is true')}
  # TODO scopes for all features, environment types

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

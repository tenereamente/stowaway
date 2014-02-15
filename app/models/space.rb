class Space < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :user
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
  # validations
  validates :title, presence: true
  validates :user_id, presence: true
  validates :address1, presence: true
  validates :city, presence: true
  #validates :state, presence: true # later make this conditional based on country
  validates :zip, presence: true # later make this conditional based on country.
  validates :notes, presence: true
  # TODO: catch Gmaps4rails address validation failure exception,
  # currently it shows up as ActiveRecord::RecordInvalid exception when running validations
  # "Gmaps4rails address Sorry, not even Google could figure out where that is:"

  # scopes
  scope :owned, -> { where('user_id is not null')}
  scope :available, -> { where('available is true')}
  scope :complete, -> { where('complete is true')}
  scope :by_user, lambda { |id| where(:user_id => id) }
  scope :by_user_indoor, lambda { |id| where(:user_id => id, :environment => "indoor") }
  scope :by_user_outdoor, lambda { |id| where(:user_id => id, :environment => "outdoor") }

  def gmaps4rails_address
    "#{self.address1}, #{self.city}, #{self.state} #{self.zip}"
  end

  def geocode?
    (!normalized_address.blank? && (lat.blank? || lng.blank?)) || address1_changed? || address2_changed? || city_changed? || zip_changed?
  end
end

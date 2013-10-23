class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :invitation_pending, -> { where(sign_in_count: 0, invitation_sent_at: nil) }

  blogs
  has_paper_trail

  has_attached_file :avatar, styles: {
    thumb: '50x50>',
    square: '200x200#',
    medium: '300x300>'
  }, :s3_protocol => :https

  has_many :space_rentals
  has_many :rentals, :source => :space, :through => :space_rentals

  strip_attributes :collapse_spaces => true
  validates :email, :uniqueness => { :case_sensitive => false }
  validates_email :email # client side validation of email address

  # override Devise method
  # no password is required when the account is created; validate password when the user sets one
  validates_confirmation_of :password
  def password_required?
    if !persisted?
      !(password != "")
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  # override Devise method so that people joining the waiting list don't get invited yet
  #def confirmation_required?
  #  false
  #end

  # override Devise method
  def active_for_authentication?
    confirmed? || confirmation_period_valid?
  end

  def send_reset_password_instructions
    if self.confirmed?
      super
    else
      errors.add :base, "You must receive an invitation before you set your password."
    end
  end
  
end

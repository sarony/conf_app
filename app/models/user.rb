class User < ActiveRecord::Base
  before_save { email.downcase! }

  validates :first_name, :presence => true, length: { maximum: 50 }
  validates :last_name,  :presence => true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
  									format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false }
  
  has_secure_password
  validates :password, :length => { minimum: 8 },
  										 :presence => { :on => :create }
  validates :password_confirmation, :presence => { :on => :create }
end
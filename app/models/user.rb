class User < ActiveRecord::Base
  
  attr_accessor :password, :auth_token, :is_requester

  has_one :session

  has_many :friends
  
  before_save :encrypt_password

  validates :username, length: { in: 1..20, message: "must be between 1 and 15 characters" }
  validates :username, uniqueness: true
  validates_format_of :username, :with => /[a-z0-9]+/i, :message => "can only contain letters and numbers"

  validates :password, length: { in: 6..20, message: "must be between 6 and 20 characters" }, if: :password_entered
  
  def is_owner?(requester)
    self === requester
  end
  
  protected

  def password_entered
    !password.nil?
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end 

end

class Session < ActiveRecord::Base
  belongs_to :user
  
  validates :auth_token, uniqueness: true
  
  def generate_token(user_id)
    begin
      auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: auth_token)
    
    self.auth_token = auth_token
    self.user_id = user_id 
  end
end

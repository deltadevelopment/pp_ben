class Message < ActiveRecord::Base

  attr_accessor :media_url

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :parent, class_name: 'Message', dependent: :destroy

  validates :body, length: {in: 1..100, message: "must be between 1 and 100 characters"}
  validates :media_key, length: { in: 1..100, message: "must be present" }, uniqueness: true
  validates :media_type, numericality: { greater_than: 0, message: "must be of type 1 or 2" }  

  validates :sender_id, presence: true
  validates :receiver_id, presence: true


  def generate_download_uri
    obj = Aws::S3::Object.new(bucket_name: ENV['S3_BUCKET'], key: self.media_key)
    self.media_url = obj.presigned_url(:get, expires_in: 300)
  end

end

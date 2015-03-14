class MessagesController < ApplicationController
  # Update to include every action that requires a key present
  before_action :check_session

  def show
    message = Message.find_by!(:sender_id => params[:sender_id], :receiver_id => params[:receiver_id])

    sender = User.find(params[:sender_id])
    receiever = User.find(params[:receiver_id])

    return not_authorized unless current_user == sender or current_user == receiver

    message.generate_download_uri unless message.media_key.nil?


    if parent_message_id.nil?
      message.update_attributes(seen: true)
    else
      message.destroy 
    end

    render json: message
  end

  def create
    message = Message.new(sender_id: params[:sender_id], receiver_id: params[:receiver_id], create_params)

    return not_authorized unless current_user == User.find(params[:sender_id])
    
    if message.save
      resource_created
    else
      check_errors_or_500
    end  
  end 

  def generate_upload_url

    s3 = Aws::S3::Resource.new
    key = SecureRandom::hex(40)
    
    obj = s3.bucket(ENV['S3_BUCKET']).object(key)
    url = URI::parse(obj.presigned_url(:put))

    res = { :url => url.to_s, :key => key }.to_json

    render json: res, status: 200

  end

  def destroy
    message = Message.find(params[:id])  

    return not_authorized unless current_user == message.receiver

    if message.destroy
      resource_destroyed
    else      
      internal_server_error
    end

  end

  private

  def create_params 
    params.require(:message).permit(:body, :media_key, :media_type)
  end

end

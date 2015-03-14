class FriendsController < ApplicationController

  before_action :check_session

  def list
    friends = Friend.where(["user_id=? OR friend_id=?", params[:id], params[:id]])
    user = User.find(params[:id])

    return not_authorized unless current_user == user

    unless friends.empty?
      render json: friends, each_serializer: FriendsSerializer
    else
      record_not_found
    end

  end

  def list_requests
    your_requests = FriendRequest.where(user_id: params[:id])

    their_requests = FriendRequest.where(friend_id: params[:id])

    user = User.find(params[:id])

    requests = []
    
    your_requests.each do |yr|
      yr.friend.is_requester = true
      requests.push(yr.friend)
    end

    their_requests.each do |tr|
      tr.user.is_requester = false
      requests.push(tr.user)
    end

    return not_authorized unless current_user == user

    unless their_requests.empty? and your_requests.empty?
      render json: requests, each_serializer: FriendRequestSerializer
    else
      record_not_found
    end
  end
  
  def create_request
    user = User.find_by_id!(params[:id])
    friend = User.find_by_id!(params[:friend_id])

    request1 = FriendRequest.where(user_id: user.id, friend_id: friend.id)

    request2 = FriendRequest.where(user_id: friend.id, friend_id: user.id)

    return not_authorized unless current_user == user
    
    if request1.empty? and request2.empty?
      request_created if FriendRequest.create(user_id: user.id, friend_id: friend.id)
    elsif !request2.empty?
      create(friend.id, user.id)
    else
      resource_could_not_be_created
    end
  end

  def accept_request 
    friend_request = FriendRequest.find_by_user_id_and_friend_id!(params[:friend_id], params[:id]) 

    return not_authorized unless current_user.id == friend_request.friend.id

    create(friend_request.user_id, friend_request.friend_id)

  end

  def create(user_id, friend_id)
    friend = Friend.new(user_id: user_id, friend_id: friend_id)
    friend_requests = FriendRequest.where(["(user_id=? AND friend_id=?) OR (user_id=? AND friend_id=?)", params[:id], params[:friend_id], params[:friend_id], params[:id]])
    friends_exists = Friend.where(["(user_id=? AND friend_id=?) OR (user_id=? AND friend_id=?)", params[:id], params[:friend_id], params[:friend_id], params[:id]])
  
    if friends_exists.empty?
      if friend.save
        friend_requests.each { |fr| fr.destroy }
        resource_created 
      else
        resource_could_not_be_created
      end
    else
      friend_requests.each { |fr| fr.destroy }
    end

  end

  def destroy 
    user = User.find(params[:id])
    friend = Friend.where(["(user_id=? AND friend_id=?) OR (user_id=? AND friend_id=?)", params[:id], params[:friend_id], params[:friend_id], params[:id]]).take!


    return not_authorized unless current_user == user
    
    if friend.destroy
      resource_destroyed
    else
      internal_server_error
    end 

  end

end

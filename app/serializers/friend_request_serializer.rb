class FriendRequestSerializer < ActiveModel::Serializer

  def attributes
    data = super

    data[:user] = { 'id' => object.id,
                    'username' => object.username,
                    'is_requester' => object.is_requester
                  }
    
    data
  end 

end

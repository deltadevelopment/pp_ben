class MessageSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :receiver_id, :media_type, :seen, :parent_id, :media_url, :body
  
    
  def attributes
    data = super

    correct_user = scope.is_owner?(object.sender) ? object.receiver: object.sender

    data[:id] = object.id
    data[:user] = { 'id' => correct_user.id,
                    'username' => correct_user.username,
                  }
    
    data
  end 
    


end

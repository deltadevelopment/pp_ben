class FriendsSerializer < ActiveModel::Serializer
  attributes :id

  def attributes
    data = super

    correct_user = scope.is_owner?(object.user) ? object.friend : object.user

    data[:id] = object.id
    data[:user] = { 'id' => correct_user.id,
                    'username' => correct_user.username,
                  }
    
    data
  end 

end

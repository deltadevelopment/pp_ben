class UsersController < ApplicationController
  # Update to include every action that requires a key present
  before_action :check_session, except: :create
 
  def show
    user = User.find(params[:id])
    
    render json: user
  end

  def create
    user = User.new(register_params)
    status = StatusesController.new

    if user.save
      session = Session.new
      session.generate_token(user.id)
      session.save

      user.auth_token = session.auth_token
      
      if status.create(user.id)
        render json: {success: "Resource created", user: remove_unsafe_keys(user) }.to_json, status: 201
      else
        resource_could_not_be_created 
      end
    else
      check_errors_or_500(user)
    end
  end

  def update
    user = User.find(params[:id])

    return not_authorized unless current_user == user 

    if user.update_attributes(update_params)
      render json: user, status: 200
    else
      check_errors_or_500(user)
    end

  end


  def destroy
    user = User.find_by_id(params[:id])

    return not_authorized unless current_user == user

    status = Status.find_by_user_id(user.id) 

    if user.destroy
      render json: {success: "User deleted"}.to_json
    else
      # TODO: Should be logged
      render json: {error: "Could not delete user"}.to_json, status: 500
    end
  end
  
  
  # Used in SessionsController#create
  def self.authenticate(username, password)
   
    user = User.find_by_username(username)

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      # Return false
      nil
    end

  end

  private  
  

  def remove_unsafe_keys(user)
    user.slice('id', 'display_name', 'username', 'auth_token')
  end

  def register_params 
    params.require(:user).permit(:username, :password)
  end

  def update_params 
    params.require(:user).permit(:password)
  end

end

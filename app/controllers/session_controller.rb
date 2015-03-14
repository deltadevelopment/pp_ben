class SessionsController < ApplicationController

  # Create new auth token for user
  def create
    # Match user / pass against db
    user = UsersController.authenticate(params[:username], params[:password])

    if user
      session = Session.find_by_user_id(user.id) || Session.new(user_id: user.id)
      session.generate_token(user.id)
      session.device_id = params[:device_id]

      if session.save
        render json: {success: "User was logged in", user_id: session.user_id, auth_token: session.auth_token}.to_json, status: 200
      else
        # TODO: Log this
        render json: {error: "Could not generate session token"}.to_json, status: 500
      end
    else
      render json: {error: "Bad credentials"}.to_json, status: 401
    end

  end

  # Delete auth token from session store
  def destroy
    session = Session.find_by_auth_token(get_auth_token)    
    
    if session 
      if session.destroy
        render json: {success: "User was logged out"}.to_json, status: 200
      else
        render json: {error: "User could not be logged out."}.to_json, status: 500
      end
    else
      render json: {error: "Session could not be found"}.to_json, status: 404
    end
  end

end

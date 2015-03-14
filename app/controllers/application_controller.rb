class ApplicationController < ActionController::API

  include ActionController::Serialization

  serialization_scope :current_user

  # For logging
  around_filter :global_request_logging

  def global_request_logging 
    logger.info "Content-Type: #{request.headers['CONTENT_TYPE']}"
    begin 
      yield 
    ensure 
      logger.info "response_status: #{response.status}"
    end 
  end 

  # Authorization

  def check_session
    @session = Session.find_by_auth_token(get_auth_token)
    return not_authorized unless @session
  end

  # Used for serializer
  # Needs check_session to be called in beforehand
  def current_user
    @user = User.find(@session.user_id)
  end   

  def request_created
    render json: {success: "Request created"}, status: 201
  end
  
  def invalid_token 
    render json: {error: "Invalid token", code: "invalid_token"}, status: 403 
  end

  # Checks if there are any validation errors, and renders them, or sets http status 500
  def check_errors_or_500(object)
     
    if(object.errors.messages)
      render json: object.errors.messages.to_json, status: 400
    else
      render json: {error: "Internal server error"}.to_json, status: 500
    end

  end
  def internal_server_error
      render json: {error: "Internal server error"}.to_json, status: 500
  end 

  def bad_request
      render json: {error: "Bad request"}.to_json, status: 400
  end

  # Renders not found json, and sets status to 404
  def record_not_found
    render json: {error: "Record not found"}.to_json, status: 404
  end

  def resource_created
    render json: {success: "Resource created"}.to_json, status: 201
  end

  def resource_destroyed
    render json: {success: "Resource destroyed"}.to_json, status: 200
  end

  def resource_could_not_be_created
    # TODO: This should be logged
    render json: {error: "Resource could not be created"}, status: 500
  end

  def not_authorized 
    render json: {error: "Not authorized"}.to_json, status: 403
  end

  def get_auth_token
    unless params[:auth_token].blank?
      return params[:auth_token]
    end

    unless request.headers['X-AUTH-TOKEN'].blank?
      return request.headers['X-AUTH-TOKEN']
    end

    false 
  end
end

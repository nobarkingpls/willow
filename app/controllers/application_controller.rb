class ApplicationController < ActionController::Base
  include Authentication
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :conditionally_authenticate
  before_action :require_authentication, unless: -> { request.format.json? }  # Skip for API requests

  allow_browser versions: :modern

  private

  def conditionally_authenticate
    if request.format.json?
      authenticate_api_user
    end
  end

  def authenticate_api_user
    authenticate_with_http_token do |token, _options|
      @current_user = User.find_by(api_token: token)
    end

    unless @current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def require_authentication
    redirect_to new_session_path unless authenticated?
  end
end

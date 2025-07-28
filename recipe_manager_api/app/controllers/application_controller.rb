class ApplicationController < ActionController::API
  # current user helper
  attr_reader :current_user

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    begin
      decoded = JWT.decode(header, Rails.application.credentials.secret_key_base).first
      @current_user = User.find(decoded["user_id"])
    rescue JWT::ExpiredSignature
      render json: { error: "Token has expired" }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { errors: "Unauthorized" }, status: :unauthorized
    end
  end
end

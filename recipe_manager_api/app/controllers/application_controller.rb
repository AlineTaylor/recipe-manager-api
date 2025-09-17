class ApplicationController < ActionController::API
  # current user helper
  attr_reader :current_user

  before_action :authenticate_request
  before_action :protect_demo_credentials!

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

  private

  def protect_demo_credentials!
    return unless ENV["DEMO_MODE"] == "true"
    return unless current_user&.email == "demo@example.com"

    # prevent demo user deletion
    if request.path.match?(/\/api\/v1\/users\/\d+$/)
      if request.delete?
        return render json: { error: "Demo user cannot be deleted." }, status: :forbidden
      end

      if request.patch? || request.put?
        blocked = %w[email password password_confirmation]
        incoming_keys = params.keys + Array(params[:user]&.keys)
        if (incoming_keys & blocked).any?
          return render json: { error: "Demo user's  credentials cannot be changed." }, status: :forbidden
        end
      end
    end
  end
end

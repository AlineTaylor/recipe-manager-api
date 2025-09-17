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
    # Only active when demo mode flag is enabled
    return unless ENV["DEMO_MODE"]&.downcase == "true"
    # Only enforce for the demo account
    return unless current_user&.email == "demo@example.com"

    # Match current routes: /users/:id (no /api/v1 prefix presently)
    if request.path.match?(/^\/users\/\d+$/)
      # Block deletion
      if request.delete?
        return render json: { error: "Demo user cannot be deleted." }, status: :forbidden
      end

      # Block sensitive credential or identity changes
      if request.patch? || request.put?
        blocked = %w[email password password_confirmation first_name last_name]
        # parameters could come either top-level or nested under :user
        incoming_keys = params.keys.map(&:to_s) + Array(params[:user]&.keys).map(&:to_s)
        if (incoming_keys & blocked).any?
          return render json: { error: "Demo user's credentials/profile cannot be changed." }, status: :forbidden
        end
      end
    end
  end
end

class UsersController < ApplicationController
  before_action :authenticate_request, except: [ :create ]

  def show
    @user = User.find(params[:id])
    # self-heal demo profile picture in demo mode so the demo account is consistent
    attach_demo_profile_picture!(@user) if demo_user_picture_missing?(@user)
    render json: UserBlueprint.render(@user, view: :normal), status: 200
  end

  def create
    @user = User.new(user_params)
      if params[:profile_picture].present?
        @user.profile_picture.attach(params[:profile_picture])
      end
      if @user.save
        render json: UserBlueprint.render(@user, view: :normal), status: :created
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def update
    @user = User.find(params[:id])
      if @user.update(user_params)
        if params[:profile_picture].present?
          @user.profile_picture.attach(params[:profile_picture])
        end
        render json: UserBlueprint.render(@user, view: :normal), status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end

  private

  def user_params
    params.permit(:email, :email_confirmation, :password, :password_confirmation, :first_name, :last_name, :preferred_system)
  end

  def demo_mode_enabled?
    ENV["DEMO_MODE"]&.downcase == "true"
  end

  def demo_user_picture_missing?(user)
    demo_mode_enabled? && user.email == "demo@example.com" && !user.profile_picture.attached?
  end

  def attach_demo_profile_picture!(user)
    path = Rails.root.join('app', 'assets', 'images', 'demo-user-pfp.png')
    return unless File.exist?(path)

    # attach without getting rid of it, only attach when missing
    File.open(path, 'rb') do |file|
      user.profile_picture.attach(io: file, filename: 'demo-user-pfp.png', content_type: 'image/png')
    end
  rescue => e
    Rails.logger.warn("Failed to attach demo profile picture: #{e.message}")
  end
end

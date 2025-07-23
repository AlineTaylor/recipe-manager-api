class UsersController < ApplicationController
  
  def index
    users = User.all
    render json: @user
  end

  def getUser
    user = User.find(params[:id])
    render json: @user, status: 200
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user
    else
      render json: { error: "Unable to create user." }
    end
  end

  def user_params
    params.permit(:email, :email_confirmation,:password, :password_digest, :first_name, :last_name, :preferred_system)
  end
end

class UsersController < ApplicationController

  def index
    @users = User.all
    render json: @user
  end

  def show
    @user = User.find(params[:id])
    render json: @user, status: 200
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def user_params
    params.permit(:email, :email_confirmation,:password, :first_name, :last_name, :preferred_system)
  end
end

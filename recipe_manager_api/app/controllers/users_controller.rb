class UsersController < ApplicationController

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
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end

  private

  def user_params
    params.permit(:email, :email_confirmation,:password, :password_confirmation,:first_name, :last_name, :preferred_system)
  end
end

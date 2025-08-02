class UsersController < ApplicationController
  before_action :authenticate_request, except: [ :create ]

  def show
    @user = User.find(params[:id])
    # render json: @user
    render json: UserBlueprint.render(@user, view: :normal), status: 200
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # render json: @user
      render json: UserBlueprint.render(@user, view: :normal), status: :created
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # render json: @user
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
    params.permit(:email, :email_confirmation,:password, :password_confirmation,:first_name, :last_name, :preferred_system)
  end
end

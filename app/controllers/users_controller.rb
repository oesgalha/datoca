class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    authorize(@user)
  end

  def edit
    authorize(@user)
  end

  def update
    authorize(@user)
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :handle, :bio, :location, :company, :avatar, :password)
  end
end

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
    if user_params[:password].blank?
      success = @user.update_without_password(user_params)
    else
      success = @user.update_with_password(user_params)
    end
    if success
      redirect_to @user, notice: 'Perfil atualizado com sucesso.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :handle, :bio, :location, :company, :avatar, :password, :current_password)
  end
end

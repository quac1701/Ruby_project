class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:email, :nickname, :password,
      :password_confirmation, :avatar, :avatar_cache, :remove_avatar)
  end

  def account_update_params
    params.require(:user).permit(:email, :nickname, :password, :password_confirmation,
      :current_password, :avatar, :avatar_cache, :remove_avatar)
  end
end

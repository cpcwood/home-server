class UsersController < ApplicationController
  def update
    @user.update(username_update_params)
    redirect_to(admin_user_settings_path, notice: 'User updated')
  end

  private

  def username_update_params
    params.require(:username).permit(:username, :username_confirmation)
  end
end

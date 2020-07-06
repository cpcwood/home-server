class UsersController < ApplicationController
  def update
    return redirect_to(admin_user_settings_path, alert: @user.errors.values.flatten.last) unless update_username
    redirect_to(admin_user_settings_path, notice: 'User updated')
  end

  private

  def update_section?(permitted_params)
    permitted_params.values.any?(&:present?)
  end

  def update_username
    update_section?(username_update_params) ? @user.update(username_update_params) : true
  end

  def username_update_params
    params.require(:username).permit(:username, :username_confirmation)
  end
end

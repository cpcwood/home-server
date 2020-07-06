class UsersController < ApplicationController
  before_action :check_logged_in

  def update
    return redirect_to(admin_user_settings_path, alert: 'Enter current password to update details') unless verify_current_password
    return redirect_to(admin_user_settings_path, alert: @user.errors.values.flatten.last) unless update_username
    redirect_to(admin_user_settings_path, notice: 'User updated!')
  end

  private

  def check_logged_in
    render(json: {}, status: :unauthorized) unless @user
  end

  def verify_current_password
    current_password = current_password_params[:password]
    @user.authenticate(current_password)
  end

  def current_password_params
    params.require(:current_password).permit(:password)
  end

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

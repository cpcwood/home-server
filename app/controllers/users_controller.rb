class UsersController < ApplicationController
  before_action :check_logged_in

  def update
    return redirect_to(admin_user_settings_path, alert: 'Enter current password to update details') unless verify_current_password
    update_section(username_update_params, 'Username')
    update_section(email_update_params, 'Email address')
    update_section(password_update_params, 'Password')
    update_section(mobile_number_update_params, 'Mobile number')
    redirect_to(admin_user_settings_path)
  end

  private

  def check_logged_in
    render(json: {}, status: :unauthorized) unless @user
  end

  def verify_current_password
    current_password = current_password_params[:password]
    @user.authenticate(current_password)
  end

  def update_section(permitted_params, section_name)
    update_message(@user.update(permitted_params), section_name) if update_required?(permitted_params)
  end

  def update_required?(permitted_params)
    permitted_params.values.any?(&:present?)
  end

  def update_message(result, section_name)
    result ? flash.notice = "#{section_name} updated!" : flash.alert = @user.errors.values.flatten.last
  end

  def current_password_params
    params.require(:current_password).permit(:password)
  end

  def username_update_params
    params.require(:username).permit(:username, :username_confirmation)
  end

  def email_update_params
    params.require(:email).permit(:email, :email_confirmation)
  end

  def password_update_params
    params.require(:password).permit(:password, :password_confirmation)
  end

  def mobile_number_update_params
    params.require(:mobile_number).permit(:mobile_number, :mobile_number_confirmation)
  end
end

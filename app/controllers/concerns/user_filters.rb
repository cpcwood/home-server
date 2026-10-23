module UserFilters
  extend ActiveSupport::Concern

  private

  def check_admin_logged_in
    redirect_to '/' unless @user
  end

  def require_two_factor_enrollment
    return if Rails.env.development? || @user.otp_enabled?
    redirect_to(new_admin_two_factor_auth_path, alert: 'Set up two factor authentication to continue')
  end

  def assign_user
    @user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end

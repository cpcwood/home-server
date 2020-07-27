module UserFilters
  extend ActiveSupport::Concern

  private

  def check_admin_logged_in
    redirect_to '/' unless @user
  end

  def assign_user
    @user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end

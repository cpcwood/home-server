class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :assign_user,
                :assign_site_setings

  private

  def assign_user
    @user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def assign_site_setings
    @site_settings = SiteSetting.first
  end
end

class AdminsController < ApplicationController
  before_action :check_admin_logged_in

  def general
    @user
  end

  def notifications; end

  def analytics; end

  def user_settings
    @user
  end

  def site_settings
    @site_settings = SiteSetting.first
  end

  private

  def check_admin_logged_in
    redirect_to '/' unless @user
  end
end
class AdminsController < ApplicationController
  before_action :check_admin_logged_in

  def general; end

  def notifications; end

  def analytics; end

  def user_settings; end
end
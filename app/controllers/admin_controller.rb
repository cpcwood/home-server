class AdminController < ApplicationController
  before_action :check_admin

  def index; end

  private 

  def check_admin
    redirect_to '/' unless @user
  end
end

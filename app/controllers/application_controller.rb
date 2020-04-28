class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :assign_user

  private

  def assign_user
    begin
      @user = User.find(session[:user_id]) if session[:user_id]
    rescue
      reset_session
      redirect_to('/')
    end
  end
end

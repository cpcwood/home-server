class SessionController < ApplicationController
  def login; end

  def new
    # check credentials
    user = User.find_by(email: params[:user])
    user = User.find_by(username: params[:user]) unless user
    if user && user.authenticate(params[:password])
      reset_session #reduce risk of session fixation
      session[:user_id] = user.id
      redirect_to :admin, notice: "#{user.username} welcome back to your home-server!"
    else
      redirect_to :login, alert: "User not found"
    end
  end
end

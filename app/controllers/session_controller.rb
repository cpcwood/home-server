require 'faraday'
require 'json'

class SessionController < ApplicationController
  def login; end

  def new
    if recaptcha_confirmation(params['g-recaptcha-response'])
      user = User.find_by(email: params[:user])
      user ||= User.find_by(username: params[:user])
      if user&.authenticate(params[:password])
        reset_session # reduce risk of session fixation
        session[:user_id] = user.id
        redirect_to :admin, notice: "#{user.username} welcome back to your home-server!"
      else
        redirect_to :login, alert: 'User not found'
      end
    else
      redirect_to :login, alert: 'reCaptcha failed, please try again'
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'You have been logged out'
  end

  private

  def recaptcha_confirmation(recaptcha_response)
    response = Faraday.post('https://www.google.com/recaptcha/api/siteverify') do |request|
      request.params['secret'] = Rails.application.credentials.recaptcha[:site_secret]
      request.params['response'] = recaptcha_response
    end
    JSON.parse(response.body)['success'] == true
  end
end
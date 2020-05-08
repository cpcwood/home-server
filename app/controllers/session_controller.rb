require 'faraday'
require 'json'
require 'twilio-ruby'

class SessionController < ApplicationController
  before_action :already_logged_in
  skip_before_action :already_logged_in, only: [:destroy]

  def login; end

  def new
    if recaptcha_confirmation(params['g-recaptcha-response'])
      user = User.find_by(email: params[:user])
      user ||= User.find_by(username: params[:user])
      if user.authenticate(params[:password])
        session[:two_factor_auth_id] = user.id
        redirect_to '/2fa'
      else
        redirect_to :login, alert: 'User not found'
      end
    else
      redirect_to :login, alert: 'reCaptcha failed, please try again'
    end
  end

  def send_2fa
    if session[:two_factor_auth_id]
      unless session[:auth_code_sent] == true
        client_verify_number = User.find_by(id: session[:two_factor_auth_id]).mobile_number
        client = Twilio::REST::Client.new(Rails.application.credentials.twilio[:account_sid], Rails.application.credentials.twilio[:auth_token])
        client.verify
              .services(Rails.application.credentials.twilio[:verify_service_sid])
              .verifications
              .create(to: client_verify_number, channel: 'sms')
        session[:auth_code_sent] = true
      end
      render :two_factor_auth
    else
      redirect_to(:login)
    end
  end

  def verify_2fa
    if session[:two_factor_auth_id]
      if params[:auth_code].length != 6
        redirect_to '/2fa', notice: 'Verification code must be 6 digits long'
      else
        user = User.find_by(id: session[:two_factor_auth_id])
        client = Twilio::REST::Client.new(Rails.application.credentials.twilio[:account_sid], Rails.application.credentials.twilio[:auth_token])
        verification_check = client.verify
                                   .services(Rails.application.credentials.twilio[:verify_service_sid])
                                   .verification_checks
                                   .create(to: user.mobile_number, code: params[:auth_code])
        if verification_check.status == 'approved'
          reset_session
          session[:user_id] = user.id
          redirect_to :admin, notice: "#{user.username} welcome back to your home-server!"
        else
          redirect_to '/2fa', notice: '2fa code incorrect, please try again'
        end
      end
    else
      redirect_to(:login)
    end
  end

  def reset_2fa
    session[:auth_code_sent] = nil
    redirect_to '/2fa', notice: '2fa code resent'
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'You have been logged out'
  end

  private

  def already_logged_in
    redirect_to(:admin) if session[:user_id]
  end

  def recaptcha_confirmation(recaptcha_response)
    response = Faraday.post('https://www.google.com/recaptcha/api/siteverify') do |request|
      request.params['secret'] = Rails.application.credentials.recaptcha[:site_secret]
      request.params['response'] = recaptcha_response
    end
    JSON.parse(response.body)['success'] == true
  end
end
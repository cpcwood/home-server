require 'faraday'
require 'json'
require 'twilio-ruby'

class SessionController < ApplicationController
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

  def two_factor_auth
    if session[:two_factor_auth_id]
      client_verify_number = User.find_by(id: session[:two_factor_auth_id]).mobile_number
      client = Twilio::REST::Client.new(Rails.application.credentials.twilio[:account_sid], Rails.application.credentials.twilio[:auth_token])
      client.verify
            .services(Rails.application.credentials.twilio[:verify_service_sid])
            .verifications
            .create(to: client_verify_number, channel: 'sms')
      render :two_factor_auth
    else
      redirect_to(:login)
    end
  end

  def two_factor_auth_verify
    if session[:two_factor_auth_id]
      user = User.find_by(id: session[:two_factor_auth_id])
      client = Twilio::REST::Client.new(Rails.application.credentials.twilio[:account_sid], Rails.application.credentials.twilio[:auth_token])
      verification_check = client.verify
                                 .services(Rails.application.credentials.twilio[:verify_service_sid])
                                 .verification_checks
                                 .create(to: user.mobile_number, code: params[:auth_code])
      reset_session
      if verification_check.status == 'approved'
        session[:user_id] = user.id
        redirect_to :admin, notice: "#{user.username} welcome back to your home-server!"
      else
        redirect_to :login, notice: '2fa code incorrect, please try again'
      end
    else
      redirect_to(:login)
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
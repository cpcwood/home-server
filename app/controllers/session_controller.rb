require 'faraday'
require 'json'
require 'twilio-ruby'

class SessionController < ApplicationController
  before_action :already_logged_in
  skip_before_action :already_logged_in, only: [:destroy]

  def login; end

  def new
    return redirect_to(:login, alert: 'reCaptcha failed, please try again') unless recaptcha_confirmation(sanitize(params['g-recaptcha-response']))
    # Active Model automatically sanitises input for where queries
    user = User.find_by(email: params[:user])
    user ||= User.find_by(username: params[:user])
    return redirect_to(:login, alert: 'User not found') unless user&.authenticate(params[:password])
    session[:two_factor_auth_id] = user.id
    redirect_to('/2fa', notice: 'Please enter the 6 digit code sent to mobile number assoicated with this account')
  end

  def send_2fa
    return redirect_to(:login) unless session[:two_factor_auth_id]
    unless session[:auth_code_sent] == true
      client_verify_number = User.find_by(id: session[:two_factor_auth_id]).mobile_number
      client = Twilio::REST::Client.new(Rails.application.credentials.twilio[:account_sid], Rails.application.credentials.twilio[:auth_token])
      client.verify
            .services(Rails.application.credentials.twilio[:verify_service_sid])
            .verifications
            .create(to: client_verify_number, channel: 'sms')
      session[:auth_code_sent] = true
    end
    render(:two_factor_auth)
  end

  def verify_2fa
    return redirect_to(:login) unless session[:two_factor_auth_id]
    auth_code = sanitize(params[:auth_code])
    return redirect_to('/2fa', notice: 'Verification code must be 6 digits long') if auth_code.length != 6
    user = User.find_by(id: session[:two_factor_auth_id])
    client = Twilio::REST::Client.new(Rails.application.credentials.twilio[:account_sid], Rails.application.credentials.twilio[:auth_token])
    verification_check = client.verify
                               .services(Rails.application.credentials.twilio[:verify_service_sid])
                               .verification_checks
                               .create(to: user.mobile_number, code: auth_code)
    return redirect_to('/2fa', notice: '2fa code incorrect, please try again') unless verification_check.status == 'approved'
    reset_session
    session[:user_id] = user.id
    redirect_to(:admin, notice: "#{user.username} welcome back to your home-server!")
  end

  def reset_2fa
    session[:auth_code_sent] = nil
    redirect_to '/2fa', notice: 'Two factor authentication code resent'
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def already_logged_in
    redirect_to(:admin) if session[:user_id]
  end

  def sanitize(string)
    ActiveRecord::Base.sanitize_sql(string) unless string.nil?
  end

  def recaptcha_confirmation(recaptcha_response)
    response = Faraday.post('https://www.google.com/recaptcha/api/siteverify') do |request|
      request.params['secret'] = Rails.application.credentials.recaptcha[:site_secret]
      request.params['response'] = recaptcha_response
    end
    JSON.parse(response.body)['success'] == true
  end
end
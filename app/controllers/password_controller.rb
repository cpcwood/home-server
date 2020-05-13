require 'faraday'

class PasswordController < ApplicationController
  before_action :already_logged_in

  def forgotten_password; end

  def send_reset_link
    return redirect_to(:forgotten_password, alert: 'reCaptcha failed, please try again') unless recaptcha_confirmation(sanitize(params['g-recaptcha-response']))
    PasswordResetJob.perform_later(email: sanitize(params[:email]))
    redirect_to(:login, notice: 'If the submitted email is associated with an account, a password reset link will be sent')
  end

  def reset_password
    reset_token = sanitize(params[:reset_token]) || session[:reset_token]
    @user = User.user_from_password_reset_token(reset_token)
    return redirect_to(:login, alert: 'Password reset token expired') unless @user
    session[:reset_token] = reset_token
  end

  def update_password
    @user = User.user_from_password_reset_token(session[:reset_token])
    return redirect_to(:login, alert: 'Password reset token expired') unless @user
    password = sanitize(params[:password])
    password_confirmation = sanitize(params[:password_confirmation])
    return redirect_to(:reset_password, alert: 'Password must be 8 or more charaters') unless password.length >= 8
    return redirect_to(:reset_password, alert: 'Passwords do not match') unless password == password_confirmation
    return redirect_to(:reset_password, alert: 'Password reset failed, please try again') unless @user.update_password!(password)
    session[:reset_token] = nil
    redirect_to(:login, notice: 'Password updated')
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

  def sanitize(string)
    ActiveRecord::Base.sanitize_sql(string) unless string.nil?
  end
end

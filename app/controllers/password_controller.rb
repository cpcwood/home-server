require 'faraday'

class PasswordController < ApplicationController
  def forgotten_password; end

  def send_reset_link
    if recaptcha_confirmation(params['g-recaptcha-response'])
      PasswordResetJob.perform_later(email: params[:email])
      redirect_to(:login, notice: 'If the submitted email is associated with an account, a password reset link will be sent')
    else
      redirect_to(:forgotten_password, alert: 'reCaptcha failed, please try again')
    end
  end

  def reset_password
    reset_token = params[:reset_token] || session[:reset_token]
    @user = User.user_from_password_reset_token(reset_token)
    return redirect_to(:login, alert: 'Password reset token expired') unless @user
    session[:reset_token] = params[:reset_token]
  end

  def update_password
    @user = User.user_from_password_reset_token(session[:reset_token])
    return redirect_to(:login, alert: 'Password reset token expired') unless @user
    return redirect_to(:reset_password, alert: 'Passwords do not match') unless params[:password] == params[:password_confirmation]
    if @user.update_password!(params[:password])
      session[:reset_token] = nil
      redirect_to(:login, notice: 'Password updated')
    else
      redirect_to(:reset_password, alert: 'Password reset failed, please try again')
    end
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

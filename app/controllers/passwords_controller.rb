class PasswordsController < ApplicationController
  before_action :already_logged_in

  def forgotten_password; end

  def send_reset_link
    return redirect_to(:forgotten_password, alert: 'reCaptcha failed, please try again') unless ReCaptchaService.recaptcha_valid?(sanitize(params['g-recaptcha-response']))
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
    return redirect_to(:reset_password, alert: @user.errors.messages.to_a.flatten.last) unless @user.update(password_params)
    session[:reset_token] = nil
    PasswordUpdatedJob.perform_later(user: @user)
    redirect_to(:login, notice: 'Password updated')
  end

  private

  def already_logged_in
    redirect_to(:admin) if session[:user_id]
  end

  def sanitize(string)
    ActiveRecord::Base.sanitize_sql(string) unless string.nil?
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
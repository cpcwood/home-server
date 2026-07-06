class SessionsController < ApplicationController
  before_action :already_logged_in
  skip_before_action :already_logged_in, only: [:destroy]

  def login; end

  def new
    return redirect_to(:login, alert: 'reCaptcha failed, please try again') unless ReCaptchaService.recaptcha_valid?(sanitize(params['g-recaptcha-response']))
    @user = User.find_by(email: sanitize(params[:user]))
    @user ||= User.find_by(username: sanitize(params[:user]))
    return redirect_to(:login, alert: 'User not found') unless @user&.authenticate(sanitize(params[:password]))
    TwoFactorAuthService.start(session, @user)
    return log_user_in if Rails.env.development? || !@user.otp_enabled?
    redirect_to('/2fa')
  end

  def show_2fa
    return redirect_to(:login) unless TwoFactorAuthService.started?(session)
    flash.now[:notice] = 'Enter the 6 digit code from your authenticator app' unless flash[:notice]
    render(:two_factor_auth)
  end

  def verify_2fa
    return redirect_to(:login) unless TwoFactorAuthService.started?(session)
    auth_code = sanitize(params[:auth_code])
    return redirect_to('/2fa', alert: 'Verification code must be 6 digits long') unless TwoFactorAuthService.auth_code_format_valid?(auth_code)
    return redirect_to('/2fa', alert: '2fa code incorrect, please try again') unless TwoFactorAuthService.auth_code_valid?(session: session, auth_code: auth_code)
    log_user_in
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

  def log_user_in
    @user = TwoFactorAuthService.get_user(session)
    reset_session
    session[:user_id] = @user.id
    @user.record_ip(request)
    notice = "#{@user.username} welcome back to your home-server!"
    notice += ' Two factor authentication is not set up — enable it in User Settings.' unless @user.otp_enabled?
    redirect_to(:admin, notice: notice)
  end
end
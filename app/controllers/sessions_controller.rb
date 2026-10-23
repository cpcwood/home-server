class SessionsController < ApplicationController
  before_action :already_logged_in
  skip_before_action :already_logged_in, only: [:destroy]

  def login; end

  def new
    return redirect_to(:login, alert: 'reCaptcha failed, please try again') unless ReCaptchaService.recaptcha_valid?(sanitize(params['g-recaptcha-response']))
    login_name = sanitize(params[:user]).to_s
    login_attribute = login_name.include?('@') ? :email : :username
    @user = User.authenticate_by(login_attribute => login_name, password: sanitize(params[:password]).to_s)
    return redirect_to(:login, alert: 'User not found') unless @user
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
    return lock_out_2fa if TwoFactorAuthService.locked_out?(session)
    auth_code = sanitize(params[:auth_code])
    return redirect_to('/2fa', alert: 'Verification code must be 6 digits long') unless TwoFactorAuthService.auth_code_format_valid?(auth_code)
    return reject_2fa_code unless TwoFactorAuthService.auth_code_valid?(session: session, auth_code: auth_code)
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

  def reject_2fa_code
    return lock_out_2fa if TwoFactorAuthService.locked_out?(session)
    redirect_to('/2fa', alert: '2fa code incorrect, please try again')
  end

  def lock_out_2fa
    reset_session
    redirect_to(:login, alert: 'Too many attempts, please try again in 15 minutes')
  end

  def sanitize(string)
    ActiveRecord::Base.sanitize_sql(string) unless string.nil?
  end

  def log_user_in
    @user = TwoFactorAuthService.get_user(session)
    reset_session
    session[:user_id] = @user.id
    @user.record_ip(request)
    return redirect_to(new_admin_two_factor_auth_path, notice: 'Set up two factor authentication to continue') unless @user.otp_enabled?
    redirect_to(:admin, notice: "#{@user.username} welcome back to your home-server!")
  end
end
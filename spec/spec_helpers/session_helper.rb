def password_athenticate_admin(user:, password:)
  stub_recaptcha_service
  post('/login', params: { user: user, password: password, 'g-recaptcha-response': 'test' })
end

def login
  enroll_two_factor_auth(@user)
  allow(TwoFactorAuthService).to receive(:auth_code_valid?).and_return(true)
  password_athenticate_admin(user: @user.username, password: @user_password)
  post('/2fa', params: { auth_code: '123456' })
  follow_redirect!
end

def login_without_two_factor_enrollment
  password_athenticate_admin(user: @user.username, password: @user_password)
  follow_redirect!
end

def enroll_two_factor_auth(user)
  user.update(otp_secret: ROTP::Base32.random) unless user.otp_enabled?
end

def logout
  delete('/login')
end

def stub_recaptcha_service
  allow(ReCaptchaService).to receive(:recaptcha_valid?).and_return(true)
end

def request_password_reset(user)
  reset_token = nil
  allow(PasswordMailer).to receive(:with).and_wrap_original do |original, **params|
    reset_token = params[:reset_token]
    original.call(**params)
  end
  user.send_password_reset_email!
  reset_token
end

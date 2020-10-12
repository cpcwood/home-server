def password_athenticate_admin(user:, password:)
  stub_recaptcha_service
  post '/login', params: { user: user, password: password, 'g-recaptcha-response': 'test' }
end

def login
  stub_two_factor_auth_service
  password_athenticate_admin(user: @test_user.username, password: @test_user_password)
  post '/2fa', params: { auth_code: '123456' }
  follow_redirect!
end

def logout
  delete '/login'
end

def stub_two_factor_auth_service
  allow(TwoFactorAuthService).to receive(:send_auth_code).and_return(true)
  allow(TwoFactorAuthService).to receive(:auth_code_valid?).and_return(true)
end

def stub_recaptcha_service
  allow(ReCaptchaService).to receive(:recaptcha_valid?).and_return(true)
end
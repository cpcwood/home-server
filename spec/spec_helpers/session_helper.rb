def password_athenticate_admin(user:, password:, captcha_success:)
  stub_request(:post, "https://www.google.com/recaptcha/api/siteverify?response=#{captcha_success}&secret=test")
    .to_return(status: 200, body: "{\"success\": #{captcha_success}}", headers: {})
  post '/login', params: { user: user, password: password, 'g-recaptcha-response' => captcha_success }
end

def login
  allow(TwoFactorAuthService).to receive(:auth_code_valid?).and_return(true)
  password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
  post '/2fa', params: { auth_code: '123456' }
  follow_redirect!
end

def logout
  delete '/login'
end
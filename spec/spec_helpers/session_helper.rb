def password_athenticate_admin(user:, password:)
  stub_recaptcha_service
  post('/login', params: { user: user, password: password, 'g-recaptcha-response': 'test' })
end

def login
  password_athenticate_admin(user: @user.username, password: @user_password)
  follow_redirect!
end

def logout
  delete('/login')
end

def stub_recaptcha_service
  allow(ReCaptchaService).to receive(:recaptcha_valid?).and_return(true)
end
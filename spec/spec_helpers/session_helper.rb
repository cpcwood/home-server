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

def request_password_reset(user)
  reset_token = nil
  allow(PasswordMailer).to receive(:with).and_wrap_original do |original, **params|
    reset_token = params[:reset_token]
    original.call(**params)
  end
  user.send_password_reset_email!
  reset_token
end

RSpec.describe 'Request Passwords', type: :request do
  before(:each) do
    seed_test_user
  end

  describe 'before_action' do
    it 'user logged in' do
      login
      get '/forgotten-password'
      expect(response).to redirect_to(:admin)
    end
  end

  describe 'GET /forgotten-password #forgotten_password' do
    it 'request forgotten password page' do
      get '/forgotten-password'
      expect(response).to render_template(:forgotten_password)
    end
  end

  describe 'POST /forgotten-password #send_reset_link' do
    before(:each) do
      stub_recaptcha_service
    end

    it 'invalid recaptcha' do
      allow(ReCaptchaService).to receive(:recaptcha_valid?).and_return(false)
      post '/forgotten-password', params: { email: @user.email, 'g-recaptcha-response' => 'test' }
      expect(response).to redirect_to(:forgotten_password)
      expect(flash[:alert]).to eq('reCaptcha failed, please try again')
    end

    it 'valid forgotten password request' do
      expect(PasswordResetJob).to receive(:perform_later).with(email: @user.email)
      post '/forgotten-password', params: { email: @user.email, 'g-recaptcha-response' => 'test' }
      expect(response).to redirect_to(:login)
      expect(flash[:notice]).to eq('If the submitted email is associated with an account, a password reset link will be sent')
    end
  end

  describe 'GET /reset-password #reset_password' do
    it 'invalid reset_token' do
      get '/reset-password', params: { reset_token: 'invalid-token' }
      expect(response).to redirect_to(:login)
      expect(flash[:alert]).to eq('Password reset token expired')
    end

    it 'valid reset_token' do
      allow(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now).and_return(nil)
      @user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @user.password_reset_token }
      expect(response).to render_template(:reset_password)
      expect(session[:reset_token] = @user.password_reset_token)
    end

    it 'reset token in session' do
      @user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @user.password_reset_token }
      get '/reset-password'
      expect(response).to render_template(:reset_password)
    end
  end

  describe 'POST /reset-password #update_password' do
    it 'no reset_token in session' do
      post '/reset-password', params: { password: 'unauthorized-password', password_confirmation: 'unauthorized-password' }
      expect(response).to redirect_to(:login)
      expect(flash[:alert]).to eq('Password reset token expired')
    end

    it 'password confirmations do not match' do
      @user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @user.password_reset_token }
      post '/reset-password', params: { password: 'Securepassword1', password_confirmation: 'not-the-same-password' }
      expect(response).to redirect_to(:reset_password)
      expect(flash[:alert]).to eq('Passwords do not match')
    end

    it 'invalid password' do
      @user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @user.password_reset_token }
      post '/reset-password', params: { password: 'passwor', password_confirmation: 'passwor' }
      expect(response).to redirect_to(:reset_password)
      expect(flash[:alert]).to eq('The password must have at least 8 characters')
    end

    it 'valid password reset request' do
      expect(PasswordUpdatedJob).to receive(:perform_later).with(user: @user)
      @user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @user.password_reset_token }
      post '/reset-password', params: { password: 'Securepassword2', password_confirmation: 'Securepassword2' }
      expect(response).to redirect_to(:login)
      expect(flash[:notice]).to eq('Password updated')
      @user.reload
      expect(@user.password_reset_token).to be_nil
      expect(@user.password_reset_expiry).to be_nil
    end
  end
end

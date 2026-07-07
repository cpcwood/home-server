RSpec.describe 'SessionsController', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  def enroll_user
    @user.update(otp_secret: ROTP::Base32.random)
  end

  describe 'GET /login #login ' do
    it 'Renders login page' do
      get '/login'
      expect(response).to render_template(:login)
    end

    it 'If already logged in, redirect to admin page' do
      login
      get '/login'
      expect(response).to redirect_to(:admin)
    end
  end

  describe 'POST /login #new' do
    context 'when the user has enrolled in 2fa' do
      before(:each) { enroll_user }

      it 'Redirects to 2fa page when logging in with username' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        expect(response).to redirect_to('/2fa')
        expect(session[:two_factor_auth_id]).to eq(@user.id)
        expect(session[:user_id]).to eq(nil)
      end

      it 'Redirects to 2fa page when logging in with email' do
        password_athenticate_admin(user: @user.email, password: @user_password)
        expect(response).to redirect_to('/2fa')
      end
    end

    context 'when the user has not enrolled in 2fa' do
      it 'Logs straight in with an enrollment nudge' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        expect(response).to redirect_to(:admin)
        expect(session[:user_id]).to eq(@user.id)
        follow_redirect!
        expect(flash[:notice]).to include('Two factor authentication is not set up')
      end
    end

    it 'Blocks login if user not found' do
      password_athenticate_admin(user: @user.username, password: 'nopass')
      expect(response).to redirect_to login_path
      expect(flash[:alert]).to include('User not found')
    end

    it 'Blocks login if captcha incorrect' do
      allow(ReCaptchaService).to receive(:recaptcha_valid?).and_return(false)
      post '/login', params: { user: @user.username, password: @user_password, 'g-recaptcha-response': 'test' }
      expect(response).to redirect_to login_path
      expect(flash[:alert]).to include('reCaptcha failed, please try again')
    end
  end

  describe 'GET /2fa #show_2fa' do
    it 'blocks unauthorised access' do
      get '/2fa'
      expect(response).to redirect_to('/login')
    end

    it 'If already logged in, redirect to admin page' do
      login
      get '/2fa'
      expect(response).to redirect_to(:admin)
    end

    it 'Prompts for the authenticator code' do
      enroll_user
      password_athenticate_admin(user: @user.username, password: @user_password)
      get '/2fa'
      expect(response).to render_template(:two_factor_auth)
      expect(flash[:notice]).to eq('Enter the 6 digit code from your authenticator app')
    end
  end

  describe 'POST /2fa #verify_2fa' do
    before(:each) { enroll_user }

    it 'invalid auth code format' do
      password_athenticate_admin(user: @user.username, password: @user_password)
      post '/2fa', params: { auth_code: '12345' }
      expect(response).to redirect_to('/2fa')
      expect(flash[:alert]).to include('Verification code must be 6 digits long')
    end

    it 'invalid auth code' do
      password_athenticate_admin(user: @user.username, password: @user_password)
      post '/2fa', params: { auth_code: '000000' }
      expect(flash[:alert]).to include('2fa code incorrect, please try again')
      expect(session[:user_id]).to eq(nil)
    end

    it 'successful login' do
      password_athenticate_admin(user: @user.username, password: @user_password)
      post '/2fa', params: { auth_code: ROTP::TOTP.new(@user.otp_secret).now }
      expect(response).to redirect_to(:admin)
      expect(session[:user_id]).to eq(@user.id)
      follow_redirect!
      expect(response.body).to include("#{@user.username} welcome back to your home-server!")
    end

    it 'records the login ip' do
      expect_any_instance_of(User).to receive(:record_ip)
      password_athenticate_admin(user: @user.username, password: @user_password)
      post '/2fa', params: { auth_code: ROTP::TOTP.new(@user.otp_secret).now }
    end

    it 'Block unauthorised access' do
      post '/2fa', params: { auth_code: '123456' }
      expect(response).to redirect_to('/login')
    end

    context 'after too many failed attempts' do
      it 'locks out and forces a fresh login, even with a valid code' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        5.times { post '/2fa', params: { auth_code: '000000' } }
        post '/2fa', params: { auth_code: ROTP::TOTP.new(@user.otp_secret).now }
        expect(response).to redirect_to('/login')
        expect(flash[:alert]).to include('Too many attempts, please log in again')
        expect(session[:two_factor_auth_id]).to eq(nil)
        expect(session[:user_id]).to eq(nil)
      end

      it 'clears the failure count once a valid code logs the user in' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        4.times { post '/2fa', params: { auth_code: '000000' } }
        post '/2fa', params: { auth_code: ROTP::TOTP.new(@user.otp_secret).now }
        expect(response).to redirect_to(:admin)
        expect(session[:user_id]).to eq(@user.id)
      end
    end
  end

  describe 'Session expiry' do
    it 'Resets session after 7 days of inactivity' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      login
      expect(session[:user_id]).not_to eq(nil)
      travel_to Time.zone.local(2020, 04, 25, 23, 59, 59)
      get '/'
      expect(session[:user_id]).not_to eq(nil)
      travel_to Time.zone.local(2020, 05, 03, 00, 00, 00)
      get '/'
      expect(session[:user_id]).to eq(nil)
    end
  end

  describe 'DELETE /login #destroy' do
    it 'Resets session' do
      login
      expect(session[:user_id]).not_to eq(nil)
      logout
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq(nil)
    end
  end
end

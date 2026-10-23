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
      it 'Sends the user to 2fa setup' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        expect(response).to redirect_to(new_admin_two_factor_auth_path)
        expect(session[:user_id]).to eq(@user.id)
        follow_redirect!
        expect(flash[:notice]).to include('Set up two factor authentication to continue')
      end

      it 'Keeps the user out of the rest of the admin until enrolled' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        ['/admin', '/admin/analytics', edit_admin_user_path(@user), new_admin_post_path].each do |path|
          get path
          expect(response).to redirect_to(new_admin_two_factor_auth_path)
        end
      end
    end

    it 'Blocks login if user not found' do
      password_athenticate_admin(user: @user.username, password: 'nopass')
      expect(response).to redirect_to login_path
      expect(flash[:alert]).to include('User not found')
    end

    it 'Blocks login for unknown user with the same message' do
      password_athenticate_admin(user: 'unknown-user', password: @user_password)
      expect(response).to redirect_to login_path
      expect(flash[:alert]).to include('User not found')
    end

    it 'Hashes a password even when the user does not exist' do
      expect(BCrypt::Password).to receive(:create).at_least(:once).and_call_original
      password_athenticate_admin(user: 'unknown@example.com', password: @user_password)
      expect(response).to redirect_to login_path
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
      def fail_2fa(times)
        times.times { post '/2fa', params: { auth_code: '000000' } }
      end

      it 'locks 2fa for 15 minutes, even for a valid code' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        fail_2fa(5)
        post '/2fa', params: { auth_code: ROTP::TOTP.new(@user.otp_secret).now }
        expect(response).to redirect_to('/login')
        expect(flash[:alert]).to include('Too many attempts, please try again in 15 minutes')
        expect(session[:two_factor_auth_id]).to eq(nil)
        expect(session[:user_id]).to eq(nil)
        expect(@user.reload.otp_locked?).to eq(true)
      end

      it 'keeps the lockout when an earlier session cookie is replayed' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        fresh_session_cookie = cookies['_my_session']
        fail_2fa(5)
        cookies['_my_session'] = fresh_session_cookie
        post '/2fa', params: { auth_code: ROTP::TOTP.new(@user.otp_secret).now }
        expect(response).to redirect_to('/login')
        expect(session[:user_id]).to eq(nil)
      end

      it 'keeps the lockout across a fresh password login' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        fail_2fa(5)
        password_athenticate_admin(user: @user.username, password: @user_password)
        post '/2fa', params: { auth_code: ROTP::TOTP.new(@user.otp_secret).now }
        expect(response).to redirect_to('/login')
        expect(session[:user_id]).to eq(nil)
      end

      it 'clears the failure count once a valid code logs the user in' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        fail_2fa(4)
        post '/2fa', params: { auth_code: ROTP::TOTP.new(@user.otp_secret).now }
        expect(response).to redirect_to(:admin)
        expect(@user.reload.failed_otp_attempts).to eq(0)
      end

      it 'allows login again once the lockout expires' do
        password_athenticate_admin(user: @user.username, password: @user_password)
        fail_2fa(5)
        travel 16.minutes
        password_athenticate_admin(user: @user.username, password: @user_password)
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

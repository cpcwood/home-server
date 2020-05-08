require 'rails_helper'
require 'helpers/session_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET #login /login' do
    it 'renders login page' do
      get '/login'
      expect(response).to render_template(:login)
    end

    it 'if already logged in, redirect to admin page' do
      login
      get '/login'
      expect(response).to redirect_to(:admin)
    end
  end

  describe 'POST #new /login' do
    it 'allows inital login with username' do
      password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: true)
      expect(response).to redirect_to('/2fa')
      expect(session[:two_factor_auth_id]).not_to eq(nil)
    end

    it 'allows inital login with email' do
      password_athenticate_admin(user: 'admin@example.com', password: 'Securepass1', captcha_success: true)
      expect(response).to redirect_to('/2fa')
    end

    it 'blocks login if user not found' do
      password_athenticate_admin(user: 'admin', password: 'nopass', captcha_success: true)
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include('User not found')
    end

    it 'blocks login if captcha incorrect' do
      password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: false)
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include('reCaptcha failed, please try again')
    end
  end

  describe 'GET #two_factor_auth /2fa' do
    it 'renders login page' do
      block_twilio_verification_requests
      password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: true)
      get('/2fa')
      expect(response).to render_template(:two_factor_auth)
    end

    it 'sends verify request to twilio' do
      block_twilio_verification_requests
      expect_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationList).to receive(:create).with(to: @test_user.mobile_number, channel: 'sms')
      password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: true)
      get '/2fa'
    end

    it 'block unauthorised access' do
      get '/2fa'
      expect(response).to redirect_to('/login')
    end

    it 'if already logged in, redirect to admin page' do
      login
      get '/login'
      expect(response).to redirect_to(:admin)
    end
  end

  describe 'POST #two_factor_auth_verify /2fa' do
    it 'sends verification check request to twilio' do
      block_twilio_verification_checks
      password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: true)
      auth_code = '1234'
      verification_double = double('verification', status: 'approved')
      expect_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).with(to: @test_user.mobile_number, code: auth_code).and_return(verification_double)
      post '/2fa', params: { auth_code: auth_code }
    end

    it 'allows sucessful login and gives user notice' do
      login
      expect(response.body).to include('admin welcome back to your home-server!')
    end

    it 'blocks wrong code entered and displays message' do
      block_twilio_verification_checks
      password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: true)
      auth_code = '1235'
      verification_double = double('verification', status: 'failed')
      allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).and_return(verification_double)
      post '/2fa', params: { auth_code: auth_code }
      expect(response).to redirect_to('/2fa')
      follow_redirect!
      follow_redirect!
      expect(response.body).to include('2fa code incorrect, please try again')
    end

    it 'block unauthorised access' do
      post '/2fa', params: { auth_code: '1234' }
      expect(response).to redirect_to('/login')
    end
  end

  describe 'DELETE #destroy /login' do
    it 'resets session' do
      allow(Faraday).to receive(:post).and_return(
        double('response', body: '{"success": true}', params: { secret: '', response: '' })
      )
      post '/login', params: { user: 'admin', password: 'Securepass1', 'g-recaptcha-response' => true }
      delete '/login'
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq(nil)
    end
  end
end



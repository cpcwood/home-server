require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'Request Sessions', type: :request do
  before(:each) do
    block_twilio_verification_checks
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
    it 'Allows inital login with username' do
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
      expect(response).to redirect_to('/2fa')
      expect(session[:two_factor_auth_id]).not_to eq(nil)
    end

    it 'Allows inital login with email' do
      password_athenticate_admin(user: @test_user.email, password: @test_user_password, captcha_success: true)
      expect(response).to redirect_to('/2fa')
    end

    it 'Blocks login if user not found' do
      password_athenticate_admin(user: @test_user.username, password: 'nopass', captcha_success: true)
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include('User not found')
    end

    it 'Blocks login if captcha incorrect' do
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: false)
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include('reCaptcha failed, please try again')
    end
  end

  describe 'GET /2fa #send_2fa' do
    it 'blocks unauthorised access' do
      get '/2fa'
      expect(response).to redirect_to('/login')
    end

    it 'If already logged in, redirect to admin page' do
      login
      get '/2fa'
      expect(response).to redirect_to(:admin)
    end

    it 'Renders login page' do
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
      get('/2fa')
      expect(response).to render_template(:two_factor_auth)
    end

    it 'Sends verify request to twilio' do
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
      expect(TwoFactorAuthService).to receive(:send_auth_code).and_return(true)
      get '/2fa'
      expect(response.body).to include('Please enter the 6 digit code sent to mobile number assoicated with this account')
    end

    it 'error sending auth code' do
      allow(TwoFactorAuthService).to receive(:send_auth_code).and_return(false)
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
      get '/2fa'
      expect(response.body).to include('Sorry something went wrong')
    end
  end

  describe 'POST /2fa #verify_2fa' do
    it 'Sends notice if verification code length incorrect' do
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
      post '/2fa', params: { auth_code: '1234' }
      expect(response).to redirect_to('/2fa')
      follow_redirect!
      expect(response.body).to include('Verification code must be 6 digits long')
    end

    it 'Sends verification check request to twilio' do
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
      auth_code = '123456'
      verification_double = double('verification', status: 'approved')
      expect_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).with(to: @test_user.mobile_number, code: auth_code).and_return(verification_double)
      post '/2fa', params: { auth_code: auth_code }
    end

    it 'Allows sucessful login and gives user notice' do
      login
      expect(response.body).to include("#{@test_user.username} welcome back to your home-server!")
    end

    it 'Current login details updated on sucessful login' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      login
      expect(@test_user.reload.current_login_time).to eq(Time.zone.now)
      expect(@test_user.reload.current_login_ip).to eq('127.0.0.1')
    end

    it 'Last login details updated on sucessful login' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      login
      logout
      travel_to Time.zone.local(2020, 04, 19, 01, 00, 00)
      login
      expect(@test_user.reload.current_login_time).to eq(Time.zone.now)
      expect(@test_user.reload.current_login_ip).to eq('127.0.0.1')
      expect(@test_user.reload.last_login_time).to eq(Time.zone.local(2020, 04, 19, 00, 00, 00))
      expect(@test_user.reload.last_login_ip).to eq('127.0.0.1')
    end

    it 'Resets session after 60 minutes of inactivity' do
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

    it 'Blocks wrong code entered and displays message' do
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
      auth_code = '123457'
      verification_double = double('verification', status: 'failed')
      allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).and_return(verification_double)
      post '/2fa', params: { auth_code: auth_code }
      expect(response).to redirect_to('/2fa')
      follow_redirect!
      expect(response.body).to include('2fa code incorrect, please try again')
    end

    it 'Block unauthorised access' do
      post '/2fa', params: { auth_code: '1234' }
      expect(response).to redirect_to('/login')
    end
  end

  describe 'PUT /2fa #reset_2fa' do
    it 'Resends 2fa code' do
      password_athenticate_admin(user: @test_user.username, password: @test_user_password, captcha_success: true)
      get '/2fa'
      expect(TwoFactorAuthService).to receive(:send_auth_code).and_return(true)
      put '/2fa'
      expect(session[:auth_code_sent]).to eq(nil)
      expect(response).to redirect_to('/2fa')
      follow_redirect!
      expect(response.body).to include('Two factor authentication code resent')
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



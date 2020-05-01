require 'rails_helper'
require 'helpers/session_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET #login /login' do
    it 'renders login page' do
      get '/login'
      expect(response).to render_template(:login)
    end
  end

  describe 'GET #two_factor_auth /2fa' do
    it 'renders login page' do
      block_twilio_external_requests
      password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: true)
      get('/2fa')
      expect(response).to render_template(:two_factor_auth)
    end

    it 'sends verify request to twilio' do
      block_twilio_external_requests
      expect_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationList).to receive(:create).with(to: @test_user.mobile_number, channel: 'sms')
      password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: true)
      get '/2fa'
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

  describe 'POST #two_factor_auth_verify /2fa' do
    # it 'allows sucessful login and gives user notice' do
    #   allow(Faraday).to receive(:post).and_return(
    #     double('response', body: '{"success": true}', params: { secret: '', response: '' })
    #   )
    #   post '/login', params: { user: 'admin', password: 'Securepass1', 'g-recaptcha-response' => true }
    #   follow_redirect!
    #   expect(response.body).to include('admin welcome back to your home-server!')
    # end
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



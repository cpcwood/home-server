require 'rails_helper'

RSpec.describe 'Admin::TwoFactorAuths', type: :request do
  before(:each) do
    seed_user_and_settings
    login
  end

  describe 'GET /admin/2fa-setup/new' do
    it 'shows a qr code and manual key' do
      get '/admin/2fa-setup/new'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('svg')
      expect(response.body).to include('Manual key')
    end
  end

  describe 'POST /admin/2fa-setup' do
    it 'activates totp with a valid code' do
      get '/admin/2fa-setup/new'
      pending_secret = session[:pending_otp_secret]
      post '/admin/2fa-setup', params: { auth_code: ROTP::TOTP.new(pending_secret).now }
      expect(User.first.reload.otp_enabled?).to eq(true)
    end

    it 'rejects an invalid code' do
      get '/admin/2fa-setup/new'
      post '/admin/2fa-setup', params: { auth_code: '000000' }
      expect(User.first.reload.otp_enabled?).to eq(false)
    end
  end
end

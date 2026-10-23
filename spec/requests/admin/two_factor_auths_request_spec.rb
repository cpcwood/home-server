require 'rails_helper'

RSpec.describe 'Admin::TwoFactorAuths', type: :request do
  before(:each) do
    seed_user_and_settings
    login_without_two_factor_enrollment
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
    it 'activates totp with a valid code and correct current password' do
      get '/admin/2fa-setup/new'
      pending_secret = session[:pending_otp_secret]
      post '/admin/2fa-setup', params: { auth_code: ROTP::TOTP.new(pending_secret).now, current_password: { password: @user_password }}
      expect(User.first.reload.otp_enabled?).to eq(true)
    end

    it 'emails the account owner when 2fa is enabled' do
      get '/admin/2fa-setup/new'
      pending_secret = session[:pending_otp_secret]
      expect do
        post '/admin/2fa-setup', params: { auth_code: ROTP::TOTP.new(pending_secret).now, current_password: { password: @user_password }}
      end.to have_enqueued_job(TwoFactorAuthUpdatedJob).with(user: @user)
    end

    it 'rejects an invalid code' do
      get '/admin/2fa-setup/new'
      post '/admin/2fa-setup', params: { auth_code: '000000', current_password: { password: @user_password }}
      expect(response).to redirect_to(new_admin_two_factor_auth_path)
      expect(flash[:alert]).to include('Code incorrect')
      expect(User.first.reload.otp_secret).to eq(nil)
    end

    it 'rejects enrollment with a wrong current password even with a valid code' do
      get '/admin/2fa-setup/new'
      pending_secret = session[:pending_otp_secret]
      post '/admin/2fa-setup', params: { auth_code: ROTP::TOTP.new(pending_secret).now, current_password: { password: 'wrongpassword' }}
      expect(response).to redirect_to(new_admin_two_factor_auth_path)
      expect(User.first.reload.otp_secret).to eq(nil)
    end

    it 'rejects enrollment with a blank current password even with a valid code' do
      get '/admin/2fa-setup/new'
      pending_secret = session[:pending_otp_secret]
      post '/admin/2fa-setup', params: { auth_code: ROTP::TOTP.new(pending_secret).now, current_password: { password: '' }}
      expect(response).to redirect_to(new_admin_two_factor_auth_path)
      expect(User.first.reload.otp_secret).to eq(nil)
    end

    it 'rejects a rebind by an already-enrolled user with a wrong current password, leaving the secret unchanged' do
      original_secret = ROTP::Base32.random
      User.first.update(otp_secret: original_secret)
      get '/admin/2fa-setup/new'
      pending_secret = session[:pending_otp_secret]
      post '/admin/2fa-setup', params: { auth_code: ROTP::TOTP.new(pending_secret).now, current_password: { password: 'wrongpassword' }}
      expect(response).to redirect_to(new_admin_two_factor_auth_path)
      expect(User.first.reload.otp_secret).to eq(original_secret)
    end

    context 'when 2fa is already enabled' do
      let(:original_secret) { ROTP::Base32.random }

      before(:each) do
        User.first.update(otp_secret: original_secret)
        get '/admin/2fa-setup/new'
      end

      it 'rejects a rebind without a code from the current authenticator' do
        pending_secret = session[:pending_otp_secret]
        post '/admin/2fa-setup', params: { auth_code: ROTP::TOTP.new(pending_secret).now, current_password: { password: @user_password }}
        expect(response).to redirect_to(new_admin_two_factor_auth_path)
        expect(flash[:alert]).to include('Current authenticator code incorrect')
        expect(User.first.reload.otp_secret).to eq(original_secret)
      end

      it 'rebinds with the password and a current authenticator code' do
        pending_secret = session[:pending_otp_secret]
        expect do
          post '/admin/2fa-setup', params: {
            auth_code: ROTP::TOTP.new(pending_secret).now,
            current_auth_code: ROTP::TOTP.new(original_secret).now,
            current_password: { password: @user_password }
          }
        end.to have_enqueued_job(TwoFactorAuthUpdatedJob)
        expect(User.first.reload.otp_secret).to eq(pending_secret)
      end

      it 'asks for the current authenticator code on the setup page' do
        expect(response.body).to include('current_auth_code')
      end
    end
  end

  describe 'enrollment gate' do
    it 'redirects other admin pages to 2fa setup until enrolled' do
      get '/admin'
      expect(response).to redirect_to(new_admin_two_factor_auth_path)
      expect(flash[:alert]).to include('Set up two factor authentication to continue')
    end

    it 'opens the admin once enrolled' do
      User.first.update(otp_secret: ROTP::Base32.random)
      get '/admin'
      expect(response).to have_http_status(:ok)
    end
  end
end

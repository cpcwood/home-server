require 'rails_helper'
require 'helpers/password_helpers'

RSpec.describe 'Passwords', type: :request do
  describe 'GET /forgotten-password #forgotten_password' do
    it 'Renders the forgotten password page' do
      get '/forgotten-password'
      expect(response).to render_template(:forgotten_password)
    end
  end

  describe 'POST /forgotten-password #send_reset_link' do
    it 'Redirects user back to login page, with notice of reset' do
      submit_forgotten_password(email: 'admin@example.com', captcha_success: true)
      expect(response).to redirect_to(:login)
      follow_redirect!
      expect(response.body).to include('If the submitted email is associated with an account, a password reset link will be sent')
    end

    it 'Notifies user if reCaptcha is incorrect' do
      submit_forgotten_password(email: 'admin@example.com', captcha_success: false)
      expect(response).to redirect_to(:forgotten_password)
      follow_redirect!
      expect(response.body).to include('reCaptcha failed, please try again')
    end

    it 'Password reset job created if reCaptcha sucess' do
      expect(PasswordResetJob).to receive(:perform_later).with(email: 'admin@example.com')
      submit_forgotten_password(email: 'admin@example.com', captcha_success: true)
    end
  end

  describe 'GET /reset-password #reset_password' do
    it 'Renders the reset password page if token valid' do
      allow(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now).and_return(nil)
      @test_user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @test_user.password_reset_token }
      expect(response).to render_template(:reset_password)
    end

    it 'Redirects requests without valid reset token' do
      get '/reset-password', params: { reset_token: 'invalid-token' }
      expect(response).to redirect_to(:login)
      follow_redirect!
      expect(response.body).to include('Password reset token expired')
    end

    it 'Adds reset token to session for post request' do
      @test_user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @test_user.password_reset_token }
      expect(session[:reset_token] = @test_user.password_reset_token)
    end

    it 'Redirects from with session[:reset_token] instead of querystring are allowed' do
      @test_user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @test_user.password_reset_token }
      get '/reset-password'
      expect(response).to render_template(:reset_password)
    end
  end

  describe 'POST /reset-password #update_password' do
    it 'Redirects requests without valid reset token in session' do
      post '/reset-password', params: { password: 'unauthorized-password', password_confirmation: 'unauthorized-password' }
      expect(response).to redirect_to(:login)
      follow_redirect!
      expect(response.body).to include('Password reset token expired')
    end

    it 'Alerts user and redirects back to password reset form if password and confirmation do not match' do
      @test_user.send_password_reset_email!
      get '/reset-password', params: { reset_token: @test_user.password_reset_token }
      post '/reset-password', params: { password: 'Securepassword1', password_confirmation: 'not-the-same-password' }
      expect(response).to redirect_to(:reset_password)
      follow_redirect!
      expect(response.body).to include('Passwords do not match')
    end
  end
end

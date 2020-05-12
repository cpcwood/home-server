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
    it 'Renders the reset password page' do
      get '/reset-password'
      expect(response).to render_template(:reset_password)
    end
  end
end

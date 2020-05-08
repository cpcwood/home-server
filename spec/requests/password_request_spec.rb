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

    it 'If user exists, password reset token generated' do
      expect_any_instance_of(User).to receive(:generate_password_reset_token!)
      submit_forgotten_password(email: 'admin@example.com', captcha_success: true)
    end

    it 'If user does not exist, password reset token not generated' do
      expect_any_instance_of(User).not_to receive(:generate_password_reset_token!)
      submit_forgotten_password(email: 'idontexist@example.com', captcha_success: true)
    end
  end
end

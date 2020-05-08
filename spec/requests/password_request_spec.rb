require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe 'GET /forgotten-password #forgotten_password' do
    it 'Renders the forgotten password page' do
      get '/forgotten-password'
      expect(response).to render_template(:forgotten_password)
    end
  end

  describe 'POST /forgotten-password #send_reset_link' do
    it 'Redirects user back to login page, with notice of reset' do
      captcha_success = true
      stub_request(:post, "https://www.google.com/recaptcha/api/siteverify?response=#{captcha_success}&secret=test")
        .to_return(status: 200, body: "{\"success\": #{captcha_success}}", headers: {})
      post '/forgotten-password', params: { user: 'admin', 'g-recaptcha-response' => captcha_success }
      expect(response).to redirect_to(:login)
      follow_redirect!
      expect(response.body).to include('If the submitted email is associated with an account, a password reset link will be sent')
    end

    it 'Notifies user if reCaptcha is incorrect' do
      captcha_success = false
      stub_request(:post, "https://www.google.com/recaptcha/api/siteverify?response=#{captcha_success}&secret=test")
        .to_return(status: 200, body: "{\"success\": #{captcha_success}}", headers: {})
      post '/forgotten-password', params: { user: 'admin', 'g-recaptcha-response' => captcha_success }
      expect(response).to redirect_to(:forgotten_password)
      follow_redirect!
      expect(response.body).to include('reCaptcha failed, please try again')
    end
  end
end

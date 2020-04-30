require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET #login' do
    it 'renders login page' do
      get '/login'
      expect(response).to render_template(:login)
    end
  end
  
  describe 'POST #new' do
    it 'allows sucessful login with username' do
      allow(Faraday).to receive(:post).and_return(
        double("response", body: '{"success": true}', params: {secret: '', response: ''})
      )
      post "/login", params: { user: 'admin', password: 'Securepass1', 'g-recaptcha-response' => true }
      expect(response).to redirect_to admin_path
    end

    it 'allows sucessful login with email' do
      allow(Faraday).to receive(:post).and_return(
        double("response", body: '{"success": true}', params: {secret: '', response: ''})
      )
      post "/login", params: { user: 'admin@example.com', password: 'Securepass1', 'g-recaptcha-response' => true} 
      expect(response).to redirect_to admin_path
    end

    it 'allows sucessful login and gives user notice' do
      allow(Faraday).to receive(:post).and_return(
        double("response", body: '{"success": true}', params: {secret: '', response: ''})
      )
      post "/login", params: { user: 'admin', password: 'Securepass1', 'g-recaptcha-response' => true }
      follow_redirect!
      expect(response.body).to include("admin welcome back to your home-server!")
    end

    it 'blocks login if user not found' do
      allow(Faraday).to receive(:post).and_return(
        double("response", body: '{"success": true}', params: {secret: '', response: ''})
      )
      post "/login", params: { user: 'admin', password: 'nopass', 'g-recaptcha-response' => true }
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include("User not found")
    end

    it 'blocks login if captcha not filled in' do
      post "/login", params: { user: 'admin', password: 'Securepass1'}
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include("reCaptcha failed, please try again")
    end

    it 'blocks login if captcha incorrect' do
      stub_request(:post, "https://www.google.com/recaptcha/api/siteverify?response=false&secret=test").
        with(
          headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Content-Length'=>'0',
       	  'User-Agent'=>'Faraday v1.0.0'
          }).
        to_return(status: 200, body: '{"success": false}', headers: {})
      post "/login", params: { user: 'admin', password: 'Securepass1', 'g-recaptcha-response' => false }
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include("reCaptcha failed, please try again")
    end
  end

  describe 'GET Application' do
    it 'redirects to homepage and resets session if user logged in with expired account' do
      tempuser = User.create(username: 'temp', email: 'temp@example.com', password: 'temp_pass')
      allow(Faraday).to receive(:post).and_return(
        double("response", body: '{"success": true}', params: {secret: '', response: ''})
      )
      post "/login", params: { user: 'temp', password: 'temp_pass', 'g-recaptcha-response' => true }
      tempuser.destroy
      get '/admin'
      expect(response).to redirect_to('/')
    end
  end
end



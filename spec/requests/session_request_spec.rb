require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET #login /login' do
    it 'renders login page' do
      get '/login'
      expect(response).to render_template(:login)
    end
  end

  describe 'GET #two_factor_auth /2fa' do
    it 'renders login page' do
      get '/2fa'
      expect(response).to render_template(:two_factor_auth)
    end
  end

  describe 'POST #new /login' do
    it 'allows inital login with username' do
      allow(Faraday).to receive(:post).and_return(
        double('response', body: '{"success": true}', params: { secret: '', response: '' })
      )
      post '/login', params: { user: 'admin', password: 'Securepass1', 'g-recaptcha-response' => true }
      expect(response).to redirect_to('/2fa')
      expect(session[:two_factor_auth_id]).not_to eq(nil)
    end

    it 'allows inital login with email' do
      allow(Faraday).to receive(:post).and_return(
        double('response', body: '{"success": true}', params: { secret: '', response: '' })
      )
      post '/login', params: { user: 'admin@example.com', password: 'Securepass1', 'g-recaptcha-response' => true }
      expect(response).to redirect_to('/2fa')
    end

    it 'blocks login if user not found' do
      allow(Faraday).to receive(:post).and_return(
        double('response', body: '{"success": true}', params: { secret: '', response: '' })
      )
      post '/login', params: { user: 'admin', password: 'nopass', 'g-recaptcha-response' => true }
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include('User not found')
    end

    it 'blocks login if captcha incorrect' do
      stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify?response=false&secret=test')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Length' => '0',
            'User-Agent' => 'Faraday v1.0.0'
          }
        )
        .to_return(status: 200, body: '{"success": false}', headers: {})
      post '/login', params: { user: 'admin', password: 'Securepass1', 'g-recaptcha-response' => false }
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



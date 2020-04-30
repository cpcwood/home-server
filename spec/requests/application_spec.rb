RSpec.describe 'Application', type: :request do
  describe 'Before action' do
    it 'redirects to homepage and resets session if user logged in with expired account' do
      stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify?response=true&secret=test')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Length' => '0',
            'User-Agent' => 'Faraday v1.0.0'
          }
        ).to_return(status: 200, body: '{"success": true}', headers: {})
      tempuser = User.create(username: 'temp', email: 'temp@example.com', password: 'temp_pass')
      post '/login', params: { user: 'temp', password: 'temp_pass', 'g-recaptcha-response' => true }
      tempuser.destroy
      get '/admin'
      expect(response).to redirect_to('/')
    end
  end
end
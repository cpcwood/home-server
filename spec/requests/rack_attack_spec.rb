RSpec.describe 'Rack::Attack throttles', type: :request do
  around(:each) do |example|
    original_store = Rack::Attack.cache.store
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    example.run
    Rack::Attack.cache.store = original_store
  end

  before(:each) do
    seed_user_and_settings
    stub_recaptcha_service
  end

  describe 'auth attempts' do
    it 'throttles login and 2fa posts after 20 a minute' do
      10.times { post '/login', params: { user: 'unknown', password: 'wrong' } }
      10.times { post '/2fa', params: { auth_code: '000000' } }
      post '/login', params: { user: 'unknown', password: 'wrong' }
      expect(response).to have_http_status(503)
    end

    it 'counts format-suffixed and trailing-slash paths' do
      10.times { post '/login.json', params: { user: 'unknown', password: 'wrong' } }
      10.times { post '/2fa/', params: { auth_code: '000000' } }
      post '/2fa.html', params: { auth_code: '000000' }
      expect(response).to have_http_status(503)
    end

    it 'counts paths with repeated slashes' do
      10.times { post 'http://www.example.com//login', params: { user: 'unknown', password: 'wrong' } }
      10.times { post '/2fa///', params: { auth_code: '000000' } }
      post '/login', params: { user: 'unknown', password: 'wrong' }
      expect(response).to have_http_status(503)
    end

    it 'does not throttle viewing the login page' do
      21.times { get '/login' }
      expect(response).to have_http_status(200)
    end
  end

  describe 'email sends' do
    it 'throttles password reset requests after 5 in 10 minutes' do
      5.times { post '/forgotten-password', params: { email: 'someone@example.com' } }
      post '/forgotten-password.json', params: { email: 'someone@example.com' }
      expect(response).to have_http_status(503)
    end

    it 'throttles contact messages after 5 in 10 minutes' do
      params = { contact_message: { from: 'a', email: 'a@example.com', subject: 's', content: 'c' }}
      5.times { post '/contact-messages', params: params }
      post '/contact-messages/', params: params
      expect(response).to have_http_status(503)
    end
  end
end

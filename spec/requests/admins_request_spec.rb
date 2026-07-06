RSpec.describe 'AdminsController', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  describe 'GET /admin #general' do
    it 'Redirects to homepage if user not logged in' do
      get '/admin'
      expect(response).to redirect_to('/')
    end

    it 'Displays general page as default' do
      login
      get '/admin'
      expect(response).to render_template(:general)
    end
  end

  describe 'GET /admin/notifications #notifications' do
    it 'Displays notifications page' do
      login
      get '/admin/notifications'
      expect(response).to render_template(:notifications)
    end
  end

  describe 'GET /admin/analytics #analytics' do
    before do
      login
      create(:visit, started_at: 1.day.ago)
    end

    it 'Displays analytics page' do
      get '/admin/analytics'
      expect(response).to render_template(:analytics)
    end

    it 'renders the dashboard with metrics' do
      get '/admin/analytics'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Unique visitors')
      expect(response.body).to include('United Kingdom')
    end

    it 'accepts a period param' do
      get '/admin/analytics?period=7d'
      expect(response).to have_http_status(:ok)
    end
  end
end

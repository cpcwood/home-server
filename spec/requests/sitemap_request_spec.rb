require 'rails_helper'

RSpec.describe 'Sitemap', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  describe 'GET /sitemap.xml' do
    it 'serves an XML sitemap with the static and dynamic URLs' do
      post = create(:post, user: @user)

      get '/sitemap.xml'

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('application/xml')
      expect(response.body).to include('http://www.sitemaps.org/schemas/sitemap/0.9')
      expect(response.body).to include('/blog')
      expect(response.body).to include("/blog/#{post.to_param}")
    end
  end
end

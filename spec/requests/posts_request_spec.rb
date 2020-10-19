RSpec.describe 'Posts', type: :request do
  before(:each) do
    seed_db
  end

  describe 'GET /blog' do
    it 'Renders posts index page' do
      get '/blog'
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /blog/:id' do
    it 'Renders show poge' do
      post = create(:post, user: @user)
      get("/blog/#{post.id}")
      expect(response).to render_template(:show)
    end
  end
end

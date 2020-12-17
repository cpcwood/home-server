RSpec.describe 'PostsController', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  describe 'GET /blog' do
    it 'Renders posts index page' do
      get '/blog'
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /blog/:id' do
    it 'valid post' do
      post = create(:post, user: @user)
      get("/blog/#{post.id}")
      expect(response).to render_template(:show)
    end

    it 'invalid post' do
      get('/blog/not-a-post-id')
      expect(response).to redirect_to(posts_path)
      expect(flash[:alert]).to include('Post not found')
    end
  end
end

RSpec.describe 'Request Admin:Posts', type: :request do
  before(:each) do
    seed_db
    login
  end

  describe 'GET /admin/blog #index' do
    it 'Renders page' do
      login
      get '/admin/blog'
      expect(response).to render_template(:index)
    end
  end

  describe 'POST /admin/posts #create' do
    it 'create sucessful' do
      post('/admin/posts', params: {
        post: {
          title: 'new blog post',
          overview: 'post overview',
          date_published: DateTime.new(2020, 04, 19, 0, 0, 0),
          text: 'post content'
        }
      })
      expect(response).to redirect_to(admin_posts_path)
      expect(flash[:notice]).to include('New blog post created')
      expect(Post.first).not_to be_nil
    end
  end
end

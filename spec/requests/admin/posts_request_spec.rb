RSpec.describe 'Request Admin:Posts', type: :request do
  before(:each) do
    seed_db
    login
  end

  describe 'GET /admin/blog #index' do
    it 'Renders page' do
      create(:post, user: @user)
      get '/admin/blog'
      expect(response).to render_template(:index)
    end
  end

  describe 'POST /admin/posts #create' do
    let(:valid_post_attributes) do
      { post: {
        title: 'new blog post',
        overview: 'post overview',
        date_published: DateTime.new(2020, 04, 19, 0, 0, 0),
        text: 'post content'
      }}
    end

    it 'create sucessful' do
      post('/admin/posts', params: valid_post_attributes)
      expect(response).to redirect_to(admin_posts_path)
      expect(flash[:notice]).to include('New blog post created')
      expect(Post.first).not_to be_nil
    end

    it 'Save failure' do
      allow_any_instance_of(Post).to receive(:save).and_return(false)
      allow_any_instance_of(Post).to receive(:errors).and_return({ error: 'save failure' })
      post('/admin/posts', params: valid_post_attributes)
      expect(response.body).to include('save failure')
    end

    it 'General error' do
      allow_any_instance_of(Post).to receive(:save).and_raise('general error')
      post('/admin/posts', params: valid_post_attributes)
      expect(response.body).to include('general error')
    end
  end

  describe 'PUT /admin/posts/:id #update' do
    let(:update_params) do
      { post: {
        title: 'updated blog post',
        overview: 'updated overview',
        date_published: DateTime.new(2020, 04, 19, 0, 0, 0),
        text: 'updated post content'
      }}
    end

    it 'update sucessful' do
      post = create(:post, user: @user)
      put("/admin/posts/#{post.id}", params: update_params)
      expect(response).to redirect_to(admin_posts_path)
      expect(flash[:notice]).to include('Blog post updated')
      post.reload
      expect(post.title).to eq(update_params[:post][:title])
      expect(post.overview).to eq(update_params[:post][:overview])
    end
  end
end

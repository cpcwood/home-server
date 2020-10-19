RSpec.describe 'Request Admin:Posts', type: :request do
  let(:valid_post_attributes) do
    { post: {
      title: 'new blog post',
      overview: 'post overview',
      date_published: DateTime.new(2020, 04, 19, 0, 0, 0),
      text: 'post content'
    }}
  end

  let(:invalid_post_attributes) do
    invalid_post_attribubtes = valid_post_attributes
    invalid_post_attribubtes[:post][:title] = ''
    invalid_post_attribubtes
  end

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
      expect(flash[:notice]).to include('Blog post created')
      expect(Post.first).not_to be_nil
    end

    it 'save failure' do
      post('/admin/posts', params: invalid_post_attributes)
      expect(response).not_to redirect_to(admin_posts_path)
      expect(response.body).to include('Blog post title cannot be empty')
    end

    it 'general error' do
      allow_any_instance_of(Post).to receive(:save).and_raise('general error')
      post('/admin/posts', params: valid_post_attributes)
      expect(response).not_to redirect_to(admin_posts_path)
      expect(response.body).to include('general error')
    end
  end

  describe 'PUT /admin/posts/:id #update' do
    it 'post id invalid' do
      put('/admin/posts/not-a-post-id', params: valid_post_attributes)
      expect(response).to redirect_to(admin_posts_path)
      expect(flash[:alert]).to include('Post not found')
    end

    it 'update sucessful' do
      post = create(:post, user: @user)
      put("/admin/posts/#{post.id}", params: valid_post_attributes)
      expect(response).to redirect_to(admin_posts_path)
      expect(flash[:notice]).to include('Blog post updated')
      post.reload
      expect(post.title).to eq(valid_post_attributes[:post][:title])
      expect(post.overview).to eq(valid_post_attributes[:post][:overview])
    end

    it 'save failure' do
      post = create(:post, user: @user)
      put("/admin/posts/#{post.id}", params: invalid_post_attributes)
      expect(response).not_to redirect_to(admin_posts_path)
      expect(response.body).to include('Blog post title cannot be empty')
    end

    it 'general error' do
      post = create(:post, user: @user)
      allow_any_instance_of(Post).to receive(:save).and_raise('general error')
      put("/admin/posts/#{post.id}", params: valid_post_attributes)
      expect(response).not_to redirect_to(admin_posts_path)
      expect(response.body).to include('general error')
    end
  end

  describe 'DELETE /admin/posts/:id #update' do
    it 'post id invalid' do
      delete('/admin/posts/not-a-post-id')
      expect(response).to redirect_to(admin_posts_path)
      expect(flash[:alert]).to include('Post not found')
    end

    it 'successful request' do
      post = create(:post, user: @user)
      delete("/admin/posts/#{post.id}")
      expect(response).to redirect_to(admin_posts_path)
      expect(flash[:notice]).to include('Blog post removed')
      expect(Post.find_by(id: post.id)).to be_nil
    end
  end
end

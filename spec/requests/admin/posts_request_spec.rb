RSpec.describe 'Admin::PostsController', type: :request do
  before(:each) do
    seed_user_and_settings
    login
  end



  describe 'GET /admin/posts/:id/edit #edit' do
    it 'valid request' do
      post = create(:post, user: @user)
      get "/admin/posts/#{post.id}/edit"
      expect(response).to render_template(:edit)
    end

    it 'invalid id' do
      get '/admin/posts/not-a-post-id/edit'
      expect(response).to redirect_to(posts_path)
      expect(flash[:alert]).to include('Post not found')
    end
  end



  describe 'POST /admin/posts #create' do
    let(:valid_post_attributes) do
      { post: {
        title: 'new blog post',
        overview: 'post overview',
        date_published: DateTime.new(2020, 04, 19, 0, 0, 0),
        post_sections_attributes: {
          '0': {
            text: 'new post section text 1',
            order: '0'
          },
          '1': {
            text: 'new post section text 2',
            order: '1'
          }
        }
      }}
    end
  
    let(:invalid_post_attributes) do
      invalid_post_attribubtes = valid_post_attributes
      invalid_post_attribubtes[:post][:title] = ''
      invalid_post_attribubtes
    end

    it 'create sucessful' do
      post('/admin/posts', params: valid_post_attributes)
      new_post = Post.first
      expect(response).to redirect_to(post_path(new_post))
      expect(flash[:notice]).to include('Blog post created')
      expect(new_post.post_sections.length).to eq(2)
    end

    it 'save failure' do
      post('/admin/posts', params: invalid_post_attributes)
      expect(response.body).to include('Blog post title cannot be empty')
    end

    it 'general error' do
      allow_any_instance_of(Post).to receive(:save).and_raise('general error')
      post('/admin/posts', params: valid_post_attributes)
      expect(response.body).to include('general error')
    end
  end



  describe 'PUT /admin/posts/:id #update' do
    let(:valid_post_attributes) do
      { post: {
        title: 'a current blog post',
        overview: 'post overview',
        date_published: DateTime.new(2020, 04, 19, 0, 0, 0),
        post_sections_attributes: {
          '0': {
            text: 'new post section text 1',
            order: '0'
          },
          '1': {
            text: 'new post section text 2',
            order: '1'
          }
        }
      }}
    end
  
    let(:invalid_post_attributes) do
      invalid_post_attribubtes = valid_post_attributes
      invalid_post_attribubtes[:post][:title] = ''
      invalid_post_attribubtes
    end

    it 'post id invalid' do
      put('/admin/posts/not-a-post-id', params: valid_post_attributes)
      expect(response).to redirect_to(posts_path)
      expect(flash[:alert]).to include('Post not found')
    end

    it 'update sucessful' do
      post = create(:post, user: @user)
      post_section = create(:post_section, post: post, text: 'post section text')
      valid_post_attributes[:post][:post_sections_attributes][:'0'][:id] = post_section.id
      put("/admin/posts/#{post.id}", params: valid_post_attributes)
      post.reload
      expect(response).to redirect_to(post_path(post))
      expect(flash[:notice]).to include('Blog post updated')
      expect(post.title).to eq(valid_post_attributes[:post][:title])
      expect(post.overview).to eq(valid_post_attributes[:post][:overview])
      expect(post.post_sections.first.text).to eq('new post section text 1')
      expect(post.post_sections.length).to eq(2)
    end

    it 'save failure' do
      post = create(:post, user: @user)
      put("/admin/posts/#{post.id}", params: invalid_post_attributes)
      expect(response.body).to include('Blog post title cannot be empty')
    end

    it 'general error' do
      post = create(:post, user: @user)
      allow_any_instance_of(Post).to receive(:save).and_raise('general error')
      put("/admin/posts/#{post.id}", params: valid_post_attributes)
      expect(response.body).to include('general error')
    end
  end



  describe 'DELETE /admin/posts/:id #destroy' do
    it 'post id invalid' do
      delete('/admin/posts/not-a-post-id')
      expect(response).to redirect_to(posts_path)
      expect(flash[:alert]).to include('Post not found')
    end

    it 'successful request' do
      post = create(:post, user: @user)
      delete("/admin/posts/#{post.id}")
      expect(response).to redirect_to(posts_path)
      expect(flash[:notice]).to include('Blog post removed')
      expect(Post.find_by(id: post.id)).to be_nil
    end

    it 'general error' do
      post = create(:post, user: @user)
      allow_any_instance_of(Post).to receive(:destroy).and_raise('general error')
      delete("/admin/posts/#{post.id}")
      expect(response).to redirect_to(posts_path)
      expect(flash[:alert]).to include('general error')
    end
  end
end

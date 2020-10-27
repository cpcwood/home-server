RSpec.describe 'AdminCodeSnippetsController', type: :request do
  let(:valid_attributes) do
    { code_snippet: {
      title: 'new code snippet',
      overview: 'code snippet overview',
      snippet: 'def code_snippet; end',
      extension: 'rb',
      text: 'code snippet content'
    }}
  end

  let(:invalid_attributes) do
    { code_snippet: {
      title: ''
    }}
  end

  before(:each) do
    seed_user_and_settings
    login
  end

  describe 'GET /admin/code-snippets #index' do
    it 'succesful request' do
      get('/admin/code-snippets')
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /admin/code-snippets/new #new' do
    it 'succesful request' do
      get('/admin/code-snippets/new')
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /admin/code-snippets #create' do
    it 'successful request' do
      post('/admin/code-snippets', params: valid_attributes)
      expect(flash[:notice]).to include('Code snippet created')
      expect(response).to redirect_to(admin_code_snippets_path)
    end

    it 'validation failure' do
      post('/admin/code-snippets', params: invalid_attributes)
      expect(response.body).to include('Code extension cannot be blank')
    end

    it 'general error' do
      allow_any_instance_of(CodeSnippet).to receive(:save).and_raise('general error')
      post('/admin/code-snippets', params: valid_attributes)
      expect(response.body).to include('general error')
    end
  end

  describe 'GET /admin/code-snippets/:id/edit #new' do
    it 'succesful request' do
      code_snippet = create(:code_snippet, user: @user)
      get("/admin/code-snippets/#{code_snippet.id}/edit")
      expect(response).to render_template(:edit)
    end

    it 'invalid code snippet id' do
      get('/admin/code-snippets/not-a-post-id/edit')
      expect(response).to redirect_to(admin_code_snippets_path)
      expect(flash[:alert]).to include('Code snippet not found')
    end
  end

  describe 'PUT /admin/code-snippets/:id #update' do
    it 'id invalid' do
      put('/admin/code-snippets/not-a-post-id', params: valid_attributes)
      expect(response).to redirect_to(admin_code_snippets_path)
      expect(flash[:alert]).to include('Code snippet not found')
    end

    it 'update sucessful' do
      code_snippet = create(:code_snippet, user: @user)
      put("/admin/code-snippets/#{code_snippet.id}", params: valid_attributes)
      expect(response).to redirect_to(admin_code_snippets_path)
      expect(flash[:notice]).to include('Code snippet updated')
      code_snippet.reload
      expect(code_snippet.title).to eq(valid_attributes[:code_snippet][:title])
      expect(code_snippet.overview).to eq(valid_attributes[:code_snippet][:overview])
    end

    it 'save failure' do
      code_snippet = create(:code_snippet, user: @user)
      put("/admin/code-snippets/#{code_snippet.id}", params: invalid_attributes)
      expect(response).not_to redirect_to(admin_code_snippets_path)
      expect(response.body).to include('Title length must be between 1 and 50 charaters')
    end

    it 'general error' do
      code_snippet = create(:code_snippet, user: @user)
      allow_any_instance_of(CodeSnippet).to receive(:save).and_raise('general error')
      put("/admin/code-snippets/#{code_snippet.id}", params: valid_attributes)
      expect(response).not_to redirect_to(admin_code_snippets_path)
      expect(response.body).to include('general error')
    end
  end

  describe 'DELETE /admin/code-snippets/:id #destroy' do
    it 'id invalid' do
      delete('/admin/code-snippets/not-a-post-id')
      expect(response).to redirect_to(admin_code_snippets_path)
      expect(flash[:alert]).to include('Code snippet not found')
    end

    it 'successful request' do
      code_snippet = create(:code_snippet, user: @user)
      delete("/admin/code-snippets/#{code_snippet.id}")
      expect(response).to redirect_to(admin_code_snippets_path)
      expect(flash[:notice]).to include('Code snippet removed')
      expect(CodeSnippet.find_by(id: code_snippet.id)).to be_nil
    end

    it 'general error' do
      code_snippet = create(:code_snippet, user: @user)
      allow_any_instance_of(CodeSnippet).to receive(:destroy).and_raise('general error')
      delete("/admin/code-snippets/#{code_snippet.id}")
      expect(response).to redirect_to(admin_code_snippets_path)
      expect(flash[:alert]).to include('general error')
    end
  end
end

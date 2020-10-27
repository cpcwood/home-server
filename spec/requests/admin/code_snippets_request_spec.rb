RSpec.describe 'AdminCodeSnippetsController', type: :request do
  let(:valid_attributes) do
    { code_snippet: {
      title: 'new code snippet',
      overview: 'code snippet overview',
      snippet: 'def code_snippet; end',
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
      expect(response.body).to include('Code snippet cannot be blank')
    end

    it 'general error' do
      allow_any_instance_of(CodeSnippet).to receive(:save).and_raise('general error')
      post('/admin/code-snippets', params: valid_attributes)
      expect(response.body).to include('general error')
    end
  end
end

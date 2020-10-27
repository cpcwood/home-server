RSpec.describe 'CodeSnippetsController', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  describe 'GET /code-snippets #index' do
    it 'succesful request' do
      get('/code-snippets')
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /code-snippets/:id #show' do
    it 'succesful request' do
      get('/code-snippets')
      expect(response).to render_template(:index)
    end

    it 'invalid code snippet id' do
      get('/code-snippet/not-a-post-id')
      expect(response).to redirect_to(code_snippets_path)
      expect(flash[:alert]).to include('Code snippet not found')
    end
  end
end

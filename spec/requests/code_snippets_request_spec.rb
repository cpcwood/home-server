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
end

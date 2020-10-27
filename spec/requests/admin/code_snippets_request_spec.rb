RSpec.describe 'AdminCodeSnippetsController', type: :request do
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
end

RSpec.describe 'AdminProjects', type: :request do
  before(:each) do
    seed_user_and_settings
    login
  end

  describe 'GET /admin/projects #index' do
    it 'succesful request' do
      get('/admin/projects')
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /admin/projects/new #index' do
    it 'sucessful request' do
      get '/admin/projects/new'
      expect(response).to render_template(:new)
    end
  end
end

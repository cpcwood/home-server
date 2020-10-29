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
end

RSpec.describe 'Projects', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  describe 'GET /projects #index' do
    it 'sucessful request' do
      get '/projects'
      expect(response).to render_template(:index)
    end
  end
end

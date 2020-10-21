RSpec.describe 'Admin::GalleryImages', type: :request do
  before(:each) do
    seed_user_and_settings
    login
  end

  describe 'GET /admin/gallery' do
    it 'template render' do
      get('/admin/gallery')
      expect(response).to render_template(:index)
    end
  end
end

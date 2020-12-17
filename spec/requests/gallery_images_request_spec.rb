RSpec.describe 'GalleryImagesController', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  describe 'GET /gallery #index' do
    it 'template render' do
      get('/gallery')
      expect(response).to render_template(:index)
    end
  end
end

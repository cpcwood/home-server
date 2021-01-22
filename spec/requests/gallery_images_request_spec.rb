RSpec.describe 'GalleryImagesController', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  context 'html' do
    describe 'GET /gallery #index' do
      it 'renders index' do
        get('/gallery')
        expect(response).to render_template(:index)
      end
    end
  end

  context 'json' do
    describe 'GET /gallery #index' do
      it 'json response' do
        get('/gallery.json')
        expect(response.body).to eq('test')
      end
    end
  end
end

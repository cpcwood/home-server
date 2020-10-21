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

  describe 'GET /admin/gallery-images/new' do
    it 'template render' do
      get('/admin/gallery-images/new')
      expect(response).to render_template(:new)
    end
  end

  let(:image_path) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_invalid_path) { Rails.root.join('spec/files/sample_image_invalid.jpg') }
  let(:image_fixture) { fixture_file_upload(image_path, 'image/png') }
  let(:image_fixture_invalid) { fixture_file_upload(image_invalid_path, 'image/png') }
  let(:image_file_error) { double :image_file, attach: false }

  describe 'POST /admin/gallery-images' do
    let(:valid_attributes) do
      {
        gallery_image: {
          image_file: image_fixture,
          description: 'new gallery image',
          date_taken: Date.new(2020, 04, 19),
          latitude: 180,
          longitude: -180
        }
      }
    end

    it 'successful request' do
      post('/admin/gallery-images', params: valid_attributes)
      expect(flash[:notice]).to include('Gallery image created')
      expect(response).to redirect_to(admin_gallery_images_path)
    end
  end
end

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

  let(:invalid_attributes) do
    invalid_attributes = valid_attributes
    invalid_attributes[:gallery_image][:description] = ''
    invalid_attributes
  end

  let(:invalid_image) do
    invalid_attributes = valid_attributes
    invalid_attributes[:gallery_image][:image_file] = image_fixture_invalid
    invalid_attributes
  end

  describe 'POST /admin/gallery-images' do
    it 'successful request' do
      post('/admin/gallery-images', params: valid_attributes)
      expect(flash[:notice]).to include('Gallery image created')
      expect(response).to redirect_to(admin_gallery_images_path)
    end

    it 'validation failure' do
      post('/admin/gallery-images', params: invalid_attributes)
      expect(response.body).to include('Description cannot be blank')
      expect(response).not_to redirect_to(admin_gallery_images_path)
    end

    it 'general error' do
      allow_any_instance_of(GalleryImage).to receive(:save).and_raise('general error')
      post('/admin/gallery-images', params: valid_attributes)
      expect(response.body).to include('general error')
      expect(response).not_to redirect_to(admin_gallery_images_path)
    end

    it 'invalid image' do
      post('/admin/gallery-images', params: invalid_image)
      expect(response.body).to include('Image invalid, please upload a jpeg or png file!')
      expect(response).not_to redirect_to(admin_gallery_images_path)
    end
  end
end

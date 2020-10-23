RSpec.describe 'Admin::GalleryImages', type: :request do
  let(:image_fixture) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/png') }

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
    {
      gallery_image: {
        description: ''
      }
    }
  end

  before(:each) do
    allow_any_instance_of(Image).to receive(:process_new_image_attachment).and_return(true)
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

  describe 'GET /admin/gallery-images/:id/edit' do
    it 'valid request' do
      gallery_image = create(:gallery_image, user: @user)
      get("/admin/gallery-images/#{gallery_image.id}/edit")
      expect(response).to render_template(:edit)
    end

    it 'invalid id' do
      get("/admin/gallery-images/not-a-valid-id/edit")
      expect(response).to redirect_to(admin_gallery_images_path)
      expect(flash[:alert]).to eq('Image not found')
    end
  end

  describe 'POST /admin/gallery-images' do
    it 'successful request' do
      post('/admin/gallery-images', params: valid_attributes)
      expect(flash[:notice]).to include('Gallery image created')
      expect(response).to redirect_to(admin_gallery_images_path)
    end

    it 'validation failure' do
      post('/admin/gallery-images', params: invalid_attributes)
      expect(response.body).to include('Date taken must be date')
      expect(response).not_to redirect_to(admin_gallery_images_path)
    end

    it 'general error' do
      allow_any_instance_of(GalleryImage).to receive(:save).and_raise('general error')
      post('/admin/gallery-images', params: valid_attributes)
      expect(response.body).to include('general error')
      expect(response).not_to redirect_to(admin_gallery_images_path)
    end
  end
end

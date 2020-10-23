RSpec.describe 'Admin::GalleryImages', type: :request do
  let(:image_fixture) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/png') }

  let(:valid_attributes) do
    {
      gallery_image: {
        image_file: image_fixture,
        title: 'new gallery image',
        date_taken: Date.new(2021, 04, 19),
        latitude: 180,
        longitude: -180
      }
    }
  end

  let(:invalid_attributes) do
    {
      gallery_image: {
        date_taken: ''
      }
    }
  end

  before(:each) do
    allow_any_instance_of(Image).to receive(:process_new_image_attachment).and_return(true)
    seed_user_and_settings
    login
  end

  describe 'GET /admin/gallery #index' do
    it 'template render' do
      get('/admin/gallery')
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /admin/gallery-images/new #new' do
    it 'template render' do
      get('/admin/gallery-images/new')
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /admin/gallery-images #create' do
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

  describe 'GET /admin/gallery-images/:id/edit #edit' do
    it 'valid request' do
      gallery_image = create(:gallery_image, user: @user)
      get("/admin/gallery-images/#{gallery_image.id}/edit")
      expect(response).to render_template(:edit)
    end

    it 'invalid id' do
      get('/admin/gallery-images/not-a-valid-id/edit')
      expect(response).to redirect_to(admin_gallery_images_path)
      expect(flash[:alert]).to eq('Gallery image not found')
    end
  end

  describe 'PUT /admin/gallery-images/:id #update' do
    it 'post id invalid' do
      put('/admin/gallery-images/not-a-image-id', params: valid_attributes)
      expect(response).to redirect_to(admin_gallery_images_path)
      expect(flash[:alert]).to include('Gallery image not found')
    end

    it 'update sucessful' do
      gallery_image = create(:gallery_image, user: @user)
      put("/admin/gallery-images/#{gallery_image.id}", params: valid_attributes)
      expect(response).to redirect_to(admin_gallery_images_path)
      expect(flash[:notice]).to include('Gallery image updated')
      gallery_image.reload
      expect(gallery_image.title).to eq(valid_attributes[:gallery_image][:title])
      expect(gallery_image.date_taken).to eq(valid_attributes[:gallery_image][:date_taken])
      expect(gallery_image.longitude).to eq(valid_attributes[:gallery_image][:longitude])
      expect(gallery_image.latitude).to eq(valid_attributes[:gallery_image][:latitude])
      expect(gallery_image.image_file.attached?).to eq(true)
    end

    it 'save failure' do
      gallery_image = create(:gallery_image, user: @user)
      put("/admin/gallery-images/#{gallery_image.id}", params: invalid_attributes)
      expect(response).not_to redirect_to(admin_gallery_images_path)
      expect(response.body).to include('Date taken must be date')
    end

    it 'general error' do
      gallery_image = create(:gallery_image, user: @user)
      allow_any_instance_of(GalleryImage).to receive(:save).and_raise('general error')
      put("/admin/gallery-images/#{gallery_image.id}", params: valid_attributes)
      expect(response).not_to redirect_to(admin_gallery_images_path)
      expect(response.body).to include('general error')
    end
  end

  describe 'DELETE /admin/posts/:id #update' do
    it 'post id invalid' do
      delete('/admin/gallery-images/not-a-post-id')
      expect(response).to redirect_to(admin_gallery_images_path)
      expect(flash[:alert]).to include('Gallery image not found')
    end

    it 'successful request' do
      gallery_image = create(:gallery_image, user: @user)
      delete("/admin/gallery-images/#{gallery_image.id}")
      expect(response).to redirect_to(admin_gallery_images_path)
      expect(flash[:notice]).to include('Gallery image removed')
      expect(GalleryImage.find_by(id: gallery_image.id)).to be_nil
    end

    it 'general error' do
      gallery_image = create(:gallery_image, user: @user)
      allow_any_instance_of(GalleryImage).to receive(:destroy).and_raise('general error')
      delete("/admin/gallery-images/#{gallery_image.id}")
      expect(response).to redirect_to(admin_gallery_images_path)
      expect(flash[:alert]).to include('general error')
    end
  end
end

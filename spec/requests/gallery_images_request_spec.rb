RSpec.describe 'GalleryImagesController', type: :request do
  before(:each) do
    seed_user_and_settings
    seed_gallery_image
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
        allow_any_instance_of(AttachmentHelper).to receive(:fetch_image_url).and_return('test')
        get('/gallery.json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['data'][0]['attributes']).to eq({
                                                             'title' => @gallery_image.title,
                                                             'description' => @gallery_image.description,
                                                             'thumbnail_url' => 'test',
                                                             'url' => 'test'
                                                           })
      end

      it 'paginaton' do
        seed_images = 15
        seed_images.times{ create(:gallery_image, user: @user) }
        seeded_images = 1 + seed_images
        get('/gallery.json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['data'].length).to eq([GalleryImagesController::PAGE_SIZE, seeded_images].min)
        get('/gallery.json?page=2')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['data'].length).to eq([seeded_images - GalleryImagesController::PAGE_SIZE, 0].max)
      end
    end
  end
end

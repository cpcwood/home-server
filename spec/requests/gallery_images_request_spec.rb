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
        15.times{ create(:gallery_image, user: @user) }
        get('/gallery.json')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['data'].length).to eq(12)
        get('/gallery.json?page=2')
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['data'].length).to eq(4)
      end
    end
  end
end

RSpec.describe 'Admin::ImagesController', type: :request do
  let(:image_fixture) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/png') }

  before(:each) do
    allow_any_instance_of(Image).to receive(:process_new_image_attachment).and_return(true)
    seed_user_and_settings
    login
  end

  describe 'GET /admin/images #index' do
    it 'Renders the index page' do
      get '/admin/images'
      expect(response).to render_template(:index)
    end
  end

  describe 'PUT /admin/header-images/:id #update' do
    it 'successful request' do
      put "/admin/header-images/#{@header_image.id}", params: {
        header_image: {
          image_file: image_fixture,
          x_loc: 10,
          y_loc: 15
        },
        attachment: {
          reset: '0'
        }
      }
      expect(flash[:notice]).to include('Header image updated!')
      @header_image.reload
      expect(@header_image.image_file.attached?).to eq(true)
      expect(@header_image.x_loc).to eq(10)
      expect(@header_image.y_loc).to eq(15)
    end

    it 'invalid image id' do
      put '/admin/header-images/not-a-valid-id', params: {
        header_image: {
          image_file: image_fixture,
          x_loc: 50,
          y_loc: 50
        },
        attachment: {
          reset: '0'
        }
      }
      expect(flash[:alert]).to include('Image not found')
      @header_image.reload
      expect(@header_image.image_file.attached?).to eq(false)
    end

    it 'validation failure' do
      put "/admin/header-images/#{@header_image.id}", params: {
        header_image: {
          x_loc: -1,
          y_loc: 50
        },
        attachment: {
          reset: '0'
        }
      }
      expect(flash[:alert]).to include('X loc must be in range 0-100')
      @header_image.reload
      expect(@header_image.image_file.attached?).to eq(false)
    end

    it 'general error' do
      allow_any_instance_of(HeaderImage).to receive(:save).and_raise('general error')
      put "/admin/header-images/#{@header_image.id}", params: {
        header_image: {
          image_file: image_fixture,
          x_loc: 50,
          y_loc: 50
        },
        attachment: {
          reset: '0'
        }
      }
      expect(flash[:alert]).to include('general error')
      @header_image.reload
      expect(@header_image.image_file.attached?).to eq(false)
    end

    it 'Reset to default' do
      put "/admin/header-images/#{@header_image.id}", params: {
        header_image: {
          image_file: image_fixture,
          x_loc: 50,
          y_loc: 50
        },
        attachment: {
          reset: '1'
        }
      }
      expect(flash[:notice]).to include('Header image reset!')
      @header_image.reload
      expect(@header_image.image_file.attached?).to eq(false)
    end

    describe 'PUT /admin/cover-images/:id #update' do
      it 'sucessful request' do
        put "/admin/cover-images/#{@cover_image.id}", params: {
          cover_image: {
            image_file: image_fixture,
            x_loc: 50,
            y_loc: 50
          },
          attachment: {
            reset: '0'
          }
        }
        expect(flash[:notice]).to include('Cover image updated!')
        @cover_image.reload
        expect(@cover_image.image_file.attached?).to eq(true)
      end

      it 'general error' do
        allow_any_instance_of(CoverImage).to receive(:save).and_raise('general error')
        put "/admin/cover-images/#{@cover_image.id}", params: {
          cover_image: {
            image_file: image_fixture,
            x_loc: 50,
            y_loc: 50
          },
          attachment: {
            reset: '0'
          }
        }
        expect(flash[:alert]).to include('general error')
        @cover_image.reload
        expect(@cover_image.image_file.attached?).to eq(false)
      end
    end
  end
end

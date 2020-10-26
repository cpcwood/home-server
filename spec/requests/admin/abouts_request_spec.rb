RSpec.describe 'Request Admin:Abouts', type: :request, slow: true do
  let(:image_fixture) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/png') }

  before(:each) do
    allow_any_instance_of(Image).to receive(:process_new_image_attachment).and_return(true)
    seed_user_and_settings
    seed_about
    login
  end

  describe 'GET /admin/about/edit #edit' do
    it 'Renders the index page' do
      get '/admin/about/edit'
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT /admin/about #update' do
    let(:attribute_update) do
      {
        section_title: 'new section name',
        about_me: 'new about me section',
        linkedin_link: 'http://example.com',
        github_link: 'http://example.com',
        name: 'new name',
        location: 'new location',
        contact_email: 'new@example.com'
      }
    end

    it 'Update sucessful' do
      put '/admin/about', params: {
        about: attribute_update
      }
      expect(flash[:notice]).to include('Section title updated!')
      expect(flash[:notice]).to include('About me updated!')
      expect(flash[:notice].length).to eq(attribute_update.length)
      @about.reload
      expect(@about.section_title).to eq(attribute_update[:section_title])
      expect(@about.about_me).to eq(attribute_update[:about_me])
    end

    it 'Save failure' do
      allow_any_instance_of(About).to receive(:save).and_return(false)
      allow_any_instance_of(About).to receive(:errors).and_return({ error: 'save failure' })
      put '/admin/about', params: {
        about: attribute_update
      }
      expect(response.body).to include('save failure')
    end

    it 'General error' do
      allow_any_instance_of(About).to receive(:save).and_raise('general error')
      put '/admin/about', params: {
        about: attribute_update
      }
      expect(response.body).to include('general error')
    end

    it 'upload image' do
      put '/admin/about', params: {
        about: {
          profile_image_attributes: {
            image_file: image_fixture
          }
        }
      }
      expect(@about.reload.profile_image.image_file.attached?).to be(true)
    end

    it 'remove image' do
      @about.create_profile_image(image_file: image_fixture)
      expect(@about.profile_image.image_file.attached?).to be(true)
      put '/admin/about', params: {
        about: {
          profile_image_attributes: {
            id: @about.profile_image.id,
            _destroy: '1'
          }
        }
      }
      expect(@about.reload.profile_image).to be_nil
    end
  end
end


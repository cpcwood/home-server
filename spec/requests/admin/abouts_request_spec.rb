require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'Request Admin:Abouts', type: :request, slow: true do
  let(:image_path) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_fixture) { fixture_file_upload(image_path, 'image/png') }

  before(:each) do
    login
  end

  describe 'GET /admin/about/edit #edit' do
    it 'Renders the index page' do
      get '/admin/about/edit'
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT /admin/about #update' do
    before(:each) do
      @attribute_update = {
        name: 'new section name',
        about_me: 'new about me section'
      }
    end

    it 'Update sucessful' do
      put '/admin/about', params: {
        about: @attribute_update
      }
      follow_redirect!
      expect(response.body).to include('Name updated!')
      expect(response.body).to include('About me updated!')
      @about.reload
      expect(@about.name).to eq(@attribute_update[:name])
      expect(@about.about_me).to eq(@attribute_update[:about_me])
    end

    it 'Save failure' do
      allow_any_instance_of(About).to receive(:save).and_return(false)
      allow_any_instance_of(About).to receive(:errors).and_return({ error: 'save failure' })
      put '/admin/about', params: {
        about: @attribute_update
      }
      follow_redirect!
      expect(response.body).to include('save failure')
    end

    it 'General error' do
      allow_any_instance_of(About).to receive(:save).and_raise('general error')
      put '/admin/about', params: {
        about: @attribute_update
      }
      follow_redirect!
      expect(response.body).to include('general error')
    end

    it 'upload image' do
      expect(Image).to receive(:valid?).and_call_original
      expect(Image).to receive(:resize).with(image_path: anything, x_dim: ProfileImage.new.x_dim, y_dim: ProfileImage.new.y_dim).and_call_original
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


require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'SiteSettings', type: :request do
  describe 'PUT /admin/site_setting.id #update' do
    let(:image_path) { Rails.root.join('spec/files/sample_image.jpg') }
    let(:image_invalid_path) { Rails.root.join('spec/files/sample_image_invalid.jpg') }
    let(:image_fixture) { fixture_file_upload(image_path, 'image/png') }
    let(:image_fixture_invalid) { fixture_file_upload(image_invalid_path, 'image/png') }

    before(:each) do
      login
    end

    context 'name' do
      it 'Update sucessful' do
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: 'new_site_name'
          },
          image_upload: {
            header_image: ''
          }
        }
        follow_redirect!
        expect(response.body).to include('Name updated!')
        @site_settings.reload
        expect(@site_settings.name).to eq('new_site_name')
      end

      it 'Update fails' do
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            header_image: ''
          }
        }
        follow_redirect!
        expect(response.body).to include('Site name cannot be blank')
      end
    end

    context 'header_image' do
      it 'Update sucessful' do
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            header_image: image_fixture
          }
        }
        follow_redirect!
        expect(response.body).to include('Header image updated!')
        @site_settings.reload
        expect(@site_settings.header_image.attached?).to eq(true)
      end

      it 'Update unsucessful' do
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            header_image: image_fixture_invalid
          }
        }
        follow_redirect!
        expect(response.body).to include('Header image invalid, please upload a jpeg or png file!')
        @site_settings.reload
        expect(@site_settings.header_image.attached?).to eq(false)
      end

      it 'Reset to default' do
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            header_image: image_fixture,
            header_image_reset: '1'
          }
        }
        follow_redirect!
        expect(response.body).to include('Header image reset!')
        @site_settings.reload
        expect(@site_settings.header_image.attached?).to eq(false)
      end
    end

    context 'about_image' do
      it 'Update sucessful' do
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            about_image: image_fixture
          }
        }
        follow_redirect!
        expect(response.body).to include('About image updated!')
        @site_settings.reload
        expect(@site_settings.about_image.attached?).to eq(true)
      end

      it 'Update unsucessful' do
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            about_image: image_fixture_invalid
          }
        }
        follow_redirect!
        expect(response.body).to include('About image invalid, please upload a jpeg or png file!')
        @site_settings.reload
        expect(@site_settings.header_image.attached?).to eq(false)
      end

      it 'Reset to default' do
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            about_image: image_fixture,
            about_image_reset: '1'
          }
        }
        follow_redirect!
        expect(response.body).to include('About image reset!')
        @site_settings.reload
        expect(@site_settings.header_image.attached?).to eq(false)
      end
    end
  end
end

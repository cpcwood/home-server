require 'rails_helper'
require 'helpers/session_helper'

RSpec.describe 'SiteSettings', type: :request do
  describe 'PUT /admin/site_setting.id #update' do
    let(:cover_image_path) { Rails.root.join('spec/files/sample_image_low.jpg') }

    context 'name' do
      it 'Update sucessful' do
        login
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: 'new_site_name'
          },
          image_upload: {
            cover_image: ''
          }
        }
        follow_redirect!
        expect(response.body).to include('Site name updated!')
        @site_settings.reload
        expect(@site_settings.name).to eq('new_site_name')
      end

      it 'Update fails' do
        login
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            cover_image: ''
          }
        }
        follow_redirect!
        expect(response.body).to include('Site name cannot be blank')
      end
    end

    context 'cover_image' do
      it 'Update sucessful' do
        cover_image = fixture_file_upload(cover_image_path, 'image/png')
        login
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          },
          image_upload: {
            cover_image: cover_image
          }
        }
        follow_redirect!
        expect(response.body).to include('Site cover_image updated!')
        @site_settings.reload
        expect(@site_settings.cover_image.attached?).to eq(true)
      end
    end
  end
end

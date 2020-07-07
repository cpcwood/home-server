require 'rails_helper'
require 'helpers/session_helper'

RSpec.describe 'SiteSettings', type: :request do
  describe 'PUT /admin/site_setting.id #update' do
    context 'Name' do
      it 'Update sucessful' do
        login
        put "/admin/site_settings.#{@site_settings.id}", params: {
          site_setting: {
            name: 'new_site_name'
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
          }
        }
        follow_redirect!
        expect(response.body).to include('Site name cannot be blank')
      end
    end
  end
end

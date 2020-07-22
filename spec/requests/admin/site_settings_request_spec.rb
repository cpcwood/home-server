require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'SiteSettings', type: :request, slow: true do
  before(:each) do
    login
  end

  describe 'GET /admin/site_settings #index' do
    it 'Renders the index page' do
      get '/admin/site_settings'
      expect(response).to render_template(:index)
    end
  end

  describe 'PUT /admin/site_settings/:id #update' do
    context 'name' do
      it 'Update sucessful' do
        put "/admin/site_settings/#{@site_settings.id}", params: {
          site_setting: {
            name: 'new_site_name'
          }
        }
        follow_redirect!
        expect(response.body).to include('Name updated!')
        @site_settings.reload
        expect(@site_settings.name).to eq('new_site_name')
      end

      it 'Update fails' do
        put "/admin/site_settings/#{@site_settings.id}", params: {
          site_setting: {
            name: ''
          }
        }
        follow_redirect!
        expect(response.body).to include('Site name cannot be blank')
      end
    end

    context 'header_text' do
      it 'Update sucessful' do
        put "/admin/site_settings/#{@site_settings.id}", params: {
          site_setting: {
            header_text: 'New header text'
          }
        }
        follow_redirect!
        expect(response.body).to include('Header text updated!')
        @site_settings.reload
        expect(@site_settings.header_text).to eq('New header text')
      end
    end
  end
end

require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'Request Admin:SiteSettings', type: :request, slow: true do
  before(:each) do
    login
  end

  describe 'GET /admin/site_settings #index' do
    it 'renders the index page' do
      get '/admin/site_settings'
      expect(response).to render_template(:index)
    end
  end

  describe 'PUT /admin/site_settings/:id #update' do
    it 'update unsuccessful - validations' do
      put "/admin/site_settings/#{@site_settings.id}", params: {
        site_setting: {
          name: ''
        }
      }
      follow_redirect!
      expect(response.body).to include('Site name cannot be blank')
    end

    it 'update unsuccessful - general error' do
      allow_any_instance_of(SiteSetting).to receive(:update).and_raise('general error')
      put "/admin/site_settings/#{@site_settings.id}", params: {
        site_setting: {
          name: ''
        }
      }
      follow_redirect!
      expect(response.body).to include('Sorry, something went wrong!')
      expect(response.body).to include('general error')
    end

    it 'single attribute update' do
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

    it 'multiple attribute update' do
      put "/admin/site_settings/#{@site_settings.id}", params: {
        site_setting: {
          header_text: 'New header text',
          subtitle_text: 'New subtitle text',
          typed_header_enabled: '1'
        }
      }
      follow_redirect!
      expect(response.body).to include('Header text updated!')
      expect(response.body).to include('Typed header enabled updated!')
      expect(response.body).to include('Subtitle text updated!')
      @site_settings.reload
      expect(@site_settings.header_text).to eq('New header text')
      expect(@site_settings.subtitle_text).to eq('New subtitle text')
      expect(@site_settings.typed_header_enabled).to eq(true)
    end
  end
end

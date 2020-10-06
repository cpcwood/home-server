require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'Request Admin:Abouts', type: :request, slow: true do
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
    it 'Update sucessful' do
      attribute_update = {
        name: 'new section name',
        about_me: 'new about me section'
      }
      put '/admin/about', params: {
        about: attribute_update
      }
      follow_redirect!
      expect(response.body).to include('Name updated!')
      expect(response.body).to include('About me updated!')
      @about.reload
      expect(@about.name).to eq(attribute_update[:name])
      expect(@about.about_me).to eq(attribute_update[:about_me])
    end
  end
end


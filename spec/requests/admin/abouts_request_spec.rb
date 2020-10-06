require 'rails_helper'
require 'spec_helpers/session_helper'

RSpec.describe 'Request Admin:Abouts', type: :request, slow: true do
  before(:each) do
    login
  end

  describe 'GET /admin/about #edit' do
    it 'Renders the index page' do
      get '/admin/about'
      expect(response).to render_template(:edit)
    end
  end
end

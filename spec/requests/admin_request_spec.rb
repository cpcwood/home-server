require 'rails_helper'
require 'helpers/session_helper'

RSpec.describe 'Admins', type: :request do
  describe 'GET /admin #general' do
    it 'Redirects to homepage if user not logged in' do
      get '/admin'
      expect(response).to redirect_to('/')
    end

    it 'Displays general page as default' do
      login
      get '/admin'
      expect(response).to render_template(:general)
    end
  end

  describe 'GET /admin/notifications #notifications' do
    it 'Displays notifications page' do
      login
      get '/admin/notifications'
      expect(response).to render_template(:notifications)
    end
  end
end

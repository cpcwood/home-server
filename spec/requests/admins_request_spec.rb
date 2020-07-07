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

  describe 'GET /admin/analytics #analytics' do
    it 'Displays analytics page' do
      login
      get '/admin/analytics'
      expect(response).to render_template(:analytics)
    end
  end

  describe 'GET /admin/user_settings #user_settings' do
    it 'Displays user settings page' do
      login
      get '/admin/user_settings'
      expect(response).to render_template(:user_settings)
    end
  end
end

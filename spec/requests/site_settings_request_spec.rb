require 'rails_helper'
require 'helpers/session_helper'

RSpec.describe 'SiteSettings', type: :request do
  describe 'PUT /admin/site_setting.id #update' do
    it 'Site name can be updated' do
      login
      put "/admin/site_settings.#{@site_settings.id}"
    end
  end
end

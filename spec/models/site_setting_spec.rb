require 'rails_helper'

RSpec.describe SiteSetting, type: :model do
  let(:site_setting) { SiteSetting.create(name: 'test_name') }

  describe 'Name validations' do
    it 'Rejects too short' do
      site_setting.name = ''
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:name]).to eq(['Site name cannot be blank'])
    end
  end
end

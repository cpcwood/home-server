require 'rails_helper'

RSpec.describe SiteSetting, type: :model do
  let(:site_setting) { @site_settings }

  describe 'Name validations' do
    it 'Rejects too short' do
      site_setting.name = ''
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:name]).to eq(['Site name cannot be blank'])
    end

    it 'Rejects too long' do
      site_setting.name = '0' * 256
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:name]).to eq(['Site name cannot be longer than 255 charaters'])
    end

    it 'Accepts correct length' do
      site_setting.name = '0'
      expect(site_setting).to be_valid
      site_setting.name = '0' * 255
      expect(site_setting).to be_valid
    end
  end

  describe '#update_required?' do
    it 'No update required' do
      original_name = site_setting.name
      expect(site_setting.update_required?('name', original_name)).to eq(false)
    end

    it 'Update required' do
      new_name = 'new_name'
      expect(site_setting.update_required?('name', new_name)).to eq(true)
    end
  end

  describe '#cover_images' do
    before(:each) do
      @cover_image2 = Image.create(site_setting: site_setting, name: 'cover_image2', x_dim: 1, y_dim: 1, image_type: 'cover_image')
    end

    it 'multiple images' do
      expect(site_setting.cover_images).to eq([@cover_image, @cover_image2])
    end
  end
end

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

  describe '#images_hash' do
    before(:each) do
      @cover_image = Image.create(site_setting: site_setting, name: 'cover_image', x_dim: 1, y_dim: 1)
      @header_image = Image.create(site_setting: site_setting, name: 'header_image', x_dim: 1, y_dim: 1)
    end

    it 'multiple images' do
      expect(site_setting.images_hash).to eq({ @cover_image.name.to_sym => @cover_image, @header_image.name.to_sym => @header_image })
    end
  end
end

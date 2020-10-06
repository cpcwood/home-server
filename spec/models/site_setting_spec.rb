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

  describe 'Typed_header_enabled validations' do
    it 'Data type' do
      site_setting.typed_header_enabled = nil
      expect(site_setting).to_not be_valid
      site_setting.typed_header_enabled = true
      expect(site_setting).to be_valid
    end
  end

  describe 'Header_text validations' do
    it 'Max length' do
      site_setting.header_text = '0' * 256
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:header_text]).to eq(['Header text cannot be longer than 255 charaters'])
      site_setting.header_text = '0' * 255
      expect(site_setting).to be_valid
    end
  end

  describe 'Subtitle_text validations' do
    it 'Max length' do
      site_setting.subtitle_text = '0' * 256
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:subtitle_text]).to eq(['Subtitle text cannot be longer than 255 charaters'])
      site_setting.subtitle_text = '0' * 255
      expect(site_setting).to be_valid
    end
  end

  describe '#update_required?' do
    it 'No update required' do
      original_name = site_setting.name
      expect(site_setting.update_required?(attribute: 'name', value: original_name)).to eq(false)
    end

    it 'Update required' do
      new_name = 'new_name'
      expect(site_setting.update_required?(attribute: 'name', value: new_name)).to eq(true)
    end
  end
end

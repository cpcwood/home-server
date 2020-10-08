require 'rails_helper'

RSpec.describe SiteSetting, type: :model do
  let(:site_setting) { @site_settings }

  describe 'name validations' do
    it 'rejects too short' do
      site_setting.name = ''
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:name]).to eq(['Site name cannot be blank'])
    end

    it 'rejects too long' do
      site_setting.name = '0' * 256
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:name]).to eq(['Site name cannot be longer than 255 charaters'])
    end

    it 'accepts correct length' do
      site_setting.name = '0'
      expect(site_setting).to be_valid
      site_setting.name = '0' * 255
      expect(site_setting).to be_valid
    end
  end

  describe 'typed_header_enabled validations' do
    it 'data type' do
      site_setting.typed_header_enabled = nil
      expect(site_setting).to_not be_valid
      site_setting.typed_header_enabled = true
      expect(site_setting).to be_valid
    end
  end

  describe 'header_text validations' do
    it 'max length' do
      site_setting.header_text = '0' * 256
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:header_text]).to eq(['Header text cannot be longer than 255 charaters'])
      site_setting.header_text = '0' * 255
      expect(site_setting).to be_valid
    end
  end

  describe 'subtitle_text validations' do
    it 'max length' do
      site_setting.subtitle_text = '0' * 256
      expect(site_setting).to_not be_valid
      expect(site_setting.errors.messages[:subtitle_text]).to eq(['Subtitle text cannot be longer than 255 charaters'])
      site_setting.subtitle_text = '0' * 255
      expect(site_setting).to be_valid
    end
  end

  describe '#change_messages' do
    it 'no change' do
      expect(site_setting.change_messages).to eq([])
    end
  end
end

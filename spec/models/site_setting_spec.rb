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

  describe 'header_image upload' do
    it 'Upload sucessful' do
      site_setting.header_image.attach(io: File.open(Rails.root.join('spec/files/sample_image_low.jpg')), filename: 'header_image.jpg', content_type: 'image/jpg')
      expect(site_setting.header_image.attached?).to eq(true)
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

  describe '#header_image_path' do
    it 'cover image attached' do
      site_setting.header_image.attach(io: File.open(Rails.root.join('spec/files/sample_image_low.jpg')), filename: 'header_image.jpg', content_type: 'image/jpg')
      expect(site_setting.header_image_path).to eq(site_setting.header_image)
    end

    it 'cover image not attached' do
      allow(site_setting).to receive(:default_header_image_path).and_return('test_path')
      expect(site_setting.header_image_path).to eq('test_path')
    end
  end
end

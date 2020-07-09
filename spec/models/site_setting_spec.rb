require 'rails_helper'

RSpec.describe SiteSetting, type: :model do
  let(:site_setting) { @site_settings }
  let(:image_path_valid) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_path_invalid) { Rails.root.join('spec/files/sample_image_invalid.jpg') }
  let(:text_file_path) { Rails.root.join('spec/files/sample_text.txt') }
  let(:image_gif_path) { Rails.root.join('spec/files/sample_image_gif.gif') }
  let(:image_png_path) { Rails.root.join('spec/files/sample_image_png.png') }
  let(:image_file_upload) { fixture_file_upload(image_path_valid, 'image/jpg') }

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
      site_setting.header_image.attach(image_file_upload)
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

  describe '.resize_image' do
    it 'resizes image to target dimensions' do
      target_dimensions = [2560, 300]
      processed_image = SiteSetting.resize_image(image_path: image_path_valid, x_dim: target_dimensions[0], y_dim: target_dimensions[1])
      expect(MiniMagick::Image.new(processed_image.path).dimensions).to eq(target_dimensions)
    end
  end

  describe '.image_valid?' do
    it 'image is valid jpeg' do
      expect(SiteSetting.image_valid?(image_path_valid)).to eq(true)
    end

    it 'image is invalid' do
      expect(SiteSetting.image_valid?(image_path_invalid)).to eq(false)
    end

    it 'not an image' do
      expect(SiteSetting.image_valid?(text_file_path)).to eq(false)
    end

    it 'image mime type is png' do
      expect(SiteSetting.image_valid?(image_png_path)).to eq(true)
    end

    it 'image mime type is gif' do
      expect(SiteSetting.image_valid?(image_gif_path)).to eq(false)
    end
  end
end

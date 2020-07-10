require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:site_setting) { SiteSetting.new }
  let(:image) { Image.new(name: 'test_image', site_setting: site_setting) }
  let(:image_path_valid) { Rails.root.join('spec/files/sample_image.jpg') }

  describe 'Name validations' do
    it 'Rejects too short' do
      image.name = ''
      expect(image).to_not be_valid
      expect(image.errors.messages[:name]).to eq(['Image name cannot be blank'])
    end

    it 'Rejects too long' do
      image.name = '0' * 256
      expect(image).to_not be_valid
      expect(image.errors.messages[:name]).to eq(['Image name cannot be longer than 255 charaters'])
    end

    it 'Accepts correct length' do
      image.name = '0'
      expect(image).to be_valid
      image.name = '0' * 255
      expect(image).to be_valid
    end
  end

  describe '.resize', slow: true do
    it 'resizes image to target dimensions' do
      target_dimensions = [2560, 300]
      processed_image = Image.resize(image_path: image_path_valid, x_dim: target_dimensions[0], y_dim: target_dimensions[1])
      expect(MiniMagick::Image.new(processed_image.path).dimensions).to eq(target_dimensions)
    end
  end
end

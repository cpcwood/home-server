require 'spec_helper'

describe DefaultImageHelper do
  let(:mock_image_file) { double :image_file }
  let(:header_image) { double :header_image, description: 'header_image', image_file: mock_image_file }

  describe '#image_path' do
    it 'image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(true)
      expect(helper.image_path_helper(header_image)).to eq(mock_image_file)
    end

    it 'image not attached' do
      default_image_path = 'path-to-default-image'
      allow(mock_image_file).to receive(:attached?).and_return(false)
      allow(header_image).to receive(:default_image).and_return(default_image_path)
      expect(helper.image_path_helper(header_image)).to eq(default_image_path)
    end

    it 'no image attached' do
      expect(helper.image_path_helper(nil)).to eq(DefaultImageHelper::DEFAULT_IMAGE_PATH)
    end
  end
end
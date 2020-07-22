require 'spec_helper'

describe DefaultImageHelper do
  let(:mock_image_file) { double :image_file }
  let(:header_image) { double :image, name: 'header_image', image_file: mock_image_file }
  let(:unknown_image_name) { double :image, name: 'unknown', image_file: mock_image_file }

  describe '#image_path' do
    it 'image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(true)
      expect(helper.image_path_helper(header_image)).to eq(mock_image_file)
    end

    it 'image not attached' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.image_path_helper(header_image)).to eq(DefaultImageHelper::DEFAULT_IMAGE_PATHS['header_image'])
    end

    it 'image not passed' do
      expect(helper.image_path_helper(nil)).to eq(DefaultImageHelper::DEFAULT_IMAGE_PATHS['image_not_found'])
    end

    it 'unknown image name' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.image_path_helper(unknown_image_name)).to eq(DefaultImageHelper::DEFAULT_IMAGE_PATHS['image_not_found'])
    end
  end
end
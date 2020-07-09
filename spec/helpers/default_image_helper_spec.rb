require 'spec_helper'

describe DefaultImageHelper do
  let(:header_image) { double :header_image, name: 'header_image' }

  describe '#image_path' do
    it 'image attached' do
      allow(header_image).to receive(:attached?).and_return(true)
      expect(helper.image_path(header_image)).to eq(header_image)
    end

    it 'image not attached' do
      allow(header_image).to receive(:attached?).and_return(false)
      expect(helper.image_path(header_image)).to eq(DefaultImageHelper::DEFAULT_IMAGE_PATHS['header_image'])
    end
  end
end
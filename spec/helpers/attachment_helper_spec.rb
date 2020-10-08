require 'spec_helper'

describe AttachmentHelper do
  default_image_path = 'path-to-default-image'
  let(:mock_image_file) { double :image_file }
  let(:header_image) { double :header_image, image_file: mock_image_file, default_image: default_image_path }
  let(:profile_image) { double :profile_image, image_file: mock_image_file }

  describe '#image_path_helper' do
    it 'image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(true)
      expect(helper.image_path_helper(header_image)).to eq(mock_image_file)
    end

    it 'default image method implemented' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.image_path_helper(header_image)).to eq(default_image_path)
    end

    it 'no image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.image_path_helper(profile_image)).to eq(AttachmentHelper::IMAGE_NOT_FOUND)
    end

    it 'no image passed' do
      expect(helper.image_path_helper(nil)).to eq(AttachmentHelper::IMAGE_NOT_FOUND)
    end
  end
end
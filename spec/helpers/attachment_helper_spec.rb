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

  describe '#image_file_name' do
    let(:image_path) { Rails.root.join('spec/files/sample_image.jpg') }
    let(:image_fixture) { fixture_file_upload(image_path, 'image/png') }
    let(:image_file_attached) { ProfileImage.create(image_file: image_fixture) }
    let(:image_file_not_attached) {ProfileImage.create}

    it 'no image passed' do
      expect(helper.image_file_name(image: nil)).to eq('default image')
    end

    it 'image file not attached' do
      expect(helper.image_file_name(image: image_file_not_attached)).to eq('default image')
    end

    it 'default name' do
      default_name = 'default image name'
      expect(helper.image_file_name(image: nil, default_name: default_name)).to eq(default_name)
    end

    it 'model name' do
      model_name = 'model with image attachement'
      expect(helper.image_file_name(image: nil, model_name: model_name)).to eq("default #{model_name} image")
    end

    it 'image file attached' do
      expect(helper.image_file_name(image: image_file_attached)).to eq('sample_image.jpg')
    end
  end
end
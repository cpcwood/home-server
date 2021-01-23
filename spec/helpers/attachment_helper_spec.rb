describe AttachmentHelper do
  default_image_path = 'path-to-default-image'
  let(:mock_variant) { double :variant, key: 'test-variant' }
  let(:mock_image_variant) { double :image_file_variant, blob: mock_image_file, variation: mock_variant }
  let(:mock_image_file) { double :image_file, signed_id: 'test-id', filename: 'test-name' }
  let(:header_image) { double :header_image, image_file: mock_image_file, default_image: default_image_path }
  let(:profile_image) { double :profile_image, image_file: mock_image_file }

  describe '#image_path_helper' do
    it 'image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(true)
      expect(helper.image_path_helper(image_model: header_image)).to eq(mock_image_file)
    end

    it 'default image method implemented' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.image_path_helper(image_model: header_image)).to eq(default_image_path)
    end

    it 'no image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.image_path_helper(image_model: profile_image)).to eq(AttachmentHelper::IMAGE_NOT_FOUND)
    end

    it 'no image passed' do
      expect(helper.image_path_helper(image_model: nil)).to eq(AttachmentHelper::IMAGE_NOT_FOUND)
    end

    it 'variant passed' do
      allow(mock_image_file).to receive(:attached?).and_return(true)
      allow(header_image).to receive(:variant_sizes).and_return({ thumbnail: { resize_to_limit: [100, 100] }})
      expect(mock_image_file).to receive(:variant).with({ resize_to_limit: [100, 100] })
      helper.image_path_helper(image_model: header_image, variant: :thumbnail)
    end
  end

  describe '#image_file_name' do
    let(:image_path) { Rails.root.join('spec/files/sample_image.jpg') }
    let(:image_fixture) { fixture_file_upload(image_path, 'image/png') }
    let(:image_file_attached) { build_stubbed(:profile_image, image_file: image_fixture) }
    let(:image_file_not_attached) { build_stubbed(:profile_image) }

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

  describe '#image_attached?' do
    it 'no image passed' do
      expect(helper.image_attached?(nil)).to eq(false)
    end

    it 'no image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.image_attached?(header_image)).to eq(false)
    end

    it 'image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(true)
      expect(helper.image_attached?(header_image)).to eq(true)
    end
  end

  describe '#fetch_image_url' do
    it 'no image passed' do
      expect(helper.fetch_image_url(image_model: nil)).to eq(AttachmentHelper::IMAGE_NOT_FOUND)
    end

    it 'no image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.fetch_image_url(image_model: profile_image)).to eq(AttachmentHelper::IMAGE_NOT_FOUND)
    end

    it 'default image method implemented' do
      allow(mock_image_file).to receive(:attached?).and_return(false)
      expect(helper.fetch_image_url(image_model: header_image)).to eq(default_image_path)
    end

    it 'image attached' do
      allow(mock_image_file).to receive(:attached?).and_return(true)
      expect(helper.fetch_image_url(image_model: header_image)).to eq('/rails/active_storage/blobs/test-id/test-name')
    end

    it 'variant passed' do
      allow(mock_image_file).to receive(:attached?).and_return(true)
      allow(header_image).to receive(:variant_sizes).and_return({ thumbnail: { resize_to_limit: [100, 100] }})
      allow(mock_image_file).to receive(:variant).with({ resize_to_limit: [100, 100] }).and_return(mock_image_variant)
      expect(helper.fetch_image_url(image_model: header_image, variant: :thumbnail)).to eq('/rails/active_storage/representations/test-id/test-variant/test-name')
    end
  end
end
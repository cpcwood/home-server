RSpec.describe HeaderImage, type: :model do
  subject { create(:header_image) }

  describe '#default_image' do
    it 'default value' do
      expect(subject.default_image).to eq('default_images/default_header_image.jpg')
    end
  end

  describe '#x_dim' do
    it 'default_value' do
      expect(subject.x_dim).to eq(HeaderImage::X_DIM)
    end
  end

  describe '#y_dim' do
    it 'default_value' do
      expect(subject.y_dim).to eq(HeaderImage::Y_DIM)
    end
  end
end
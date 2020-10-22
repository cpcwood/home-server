RSpec.describe CoverImage, type: :model do

  subject { create(:cover_image) }

  describe '#default_image' do
    it 'default value' do
      expect(subject.default_image).to eq('default_images/default_cover_image.jpg')
    end
  end

  describe '#x_dim' do
    it 'default_value' do
      expect(subject.x_dim).to eq(CoverImage::X_DIM)
    end
  end

  describe '#y_dim' do
    it 'default_value' do
      expect(subject.y_dim).to eq(CoverImage::Y_DIM)
    end
  end
end
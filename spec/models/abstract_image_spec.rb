RSpec.describe CoverImage, type: :model do
  let(:image) { create(:cover_image) }

  let(:image_path_valid) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_path_invalid) { Rails.root.join('spec/files/sample_image_invalid.jpg') }
  let(:text_file_path) { Rails.root.join('spec/files/sample_text.txt') }
  let(:image_gif_path) { Rails.root.join('spec/files/sample_image_gif.gif') }
  let(:image_png_path) { Rails.root.join('spec/files/sample_image_png.png') }
  let(:image_file_upload) { fixture_file_upload(image_path_valid, 'image/jpg') }

  describe 'x_loc validations' do
    it 'Presence' do
      image.x_loc = nil
      expect(image).to_not be_valid
    end

    it 'Value' do
      image.x_loc = -1
      expect(image).to_not be_valid
      image.x_loc = 0
      expect(image).to be_valid
      image.x_loc = 101
      expect(image).to_not be_valid
      image.x_loc = 100
      expect(image).to be_valid
    end
  end

  describe 'y_loc validations' do
    it 'Presence' do
      image.y_loc = nil
      expect(image).to_not be_valid
    end

    it 'Value' do
      image.y_loc = -1
      expect(image).to_not be_valid
      image.y_loc = 0
      expect(image).to be_valid
      image.y_loc = 101
      expect(image).to_not be_valid
      image.y_loc = 100
      expect(image).to be_valid
    end
  end

  describe 'description validations' do
    it 'Presence' do
      image.description = nil
      expect(image).to_not be_valid
    end

    it 'Value' do
      image.description = ''
      expect(image).to_not be_valid
    end
  end

  describe '#custom_style' do
    it 'locations are default' do
      expect(image.custom_style).to eq(nil)
    end

    it 'x_loc custom' do
      image.update(x_loc: 10)
      expect(image.custom_style).to eq('object-position: 10% 50%;')
    end

    it 'y_loc custom' do
      image.update(y_loc: 10)
      expect(image.custom_style).to eq('object-position: 50% 10%;')
    end

    it 'x_loc and y_loc custom' do
      image.update(x_loc: 10, y_loc: 90)
      expect(image.custom_style).to eq('object-position: 10% 90%;')
    end
  end

  describe '#change_messages' do
    it 'no changes' do
      image.reload
      expect(image.change_messages).to eq([])
    end

    it 'attribute change' do
      image.update(x_loc: 10, y_loc: 90)
      expect(image.change_messages).to eq(['Cover image x loc updated!', 'Cover image y loc updated!'])
    end

    it 'image update' do
      image.update(image_file: image_file_upload)
      expect(image.change_messages).to eq(['Cover image updated!'])
    end
  end

  describe '.valid?', slow: true do
    it 'image is valid jpeg' do
      expect(Image.valid?(image_path_valid)).to eq(true)
    end

    it 'image is invalid' do
      expect(Image.valid?(image_path_invalid)).to eq(false)
    end

    it 'not an image' do
      expect(Image.valid?(text_file_path)).to eq(false)
    end

    it 'image mime type is png' do
      expect(Image.valid?(image_png_path)).to eq(true)
    end

    it 'image mime type is gif' do
      expect(Image.valid?(image_gif_path)).to eq(false)
    end
  end

  describe '.resize', slow: true do
    it 'resizes image to target dimensions' do
      target_dimensions = [2560, 300]
      processed_image = Image.resize_and_fill(image_path: image_path_valid, x_dim: target_dimensions[0], y_dim: target_dimensions[1])
      expect(MiniMagick::Image.new(processed_image.path).dimensions).to eq(target_dimensions)
    end
  end
end

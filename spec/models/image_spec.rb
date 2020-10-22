RSpec.describe Image, type: :model do

  subject { create(:gallery_image) }
  let(:image_jpg_path) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_file_upload) { fixture_file_upload(image_jpg_path, 'image/jpg') }

  describe 'validations' do
    describe 'description validations' do
      it 'presence' do
        subject.description = nil
        expect(subject).to_not be_valid
      end

      it 'format' do
        subject.description = ''
        expect(subject).to_not be_valid
      end
    end
  end

  describe '#change_messages' do
    it 'no changes' do
      subject.reload
      expect(subject.change_messages).to eq([])
    end

    it 'attribute changes' do
      subject.image_file = image_file_upload
      subject.description = 'new description'
      subject.save
      expect(subject.change_messages).to eq(["#{subject.description.humanize} description updated!", "#{subject.description.humanize} updated!"])
    end
  end

  describe '.valid?' do
    it 'jpg type' do
      mock_jpg_image = double(:image, mime_type: 'image/jpeg', valid?: true)
      allow(MiniMagick::Image).to receive(:new).and_return(mock_jpg_image)
      expect(Image.valid?('jpg image path')).to eq(true)
    end

    it 'png type' do
      mock_png_image = double(:image, mime_type: 'image/png', valid?: true)
      allow(MiniMagick::Image).to receive(:new).and_return(mock_png_image)
      expect(Image.valid?('png image path')).to eq(true)
    end

    it 'invalid type' do
      mock_gif_image = double(:image, mime_type: 'image/gif', valid?: true)
      allow(MiniMagick::Image).to receive(:new).and_return(mock_gif_image)
      expect(Image.valid?('invalid image path')).to eq(false)
    end

    it 'content' do
      mock_invalid_image = double(:image, mime_type: 'image/jpeg', valid?: false)
      allow(MiniMagick::Image).to receive(:new).and_return(mock_invalid_image)
      expect(Image.valid?('invalid image path')).to eq(false)
    end
  end

  describe '.image_processing_pipeline' do
    it 'no block passed' do
      image_path = 'test_image_path.jpg'
      mock_pipeline = double(:image_processing_pipeline)
      expect(ImageProcessing::MiniMagick).to receive(:source).with(image_path).and_return(mock_pipeline)
      expect(mock_pipeline).to receive_message_chain(:strip, :saver, :convert, :call)
      Image.image_processing_pipeline(image_path: image_path)
    end

    it 'block passed' do
      image_path = 'test_image_path.jpg'
      mock_pipeline = double(:image_processing_pipeline)
      allow(ImageProcessing::MiniMagick).to receive(:source).with(image_path).and_return(mock_pipeline)
      allow(mock_pipeline).to receive_message_chain(:strip, :saver, :convert, :call)
      expect(mock_pipeline).to receive(:pipeline_method).and_return(mock_pipeline)
      Image.image_processing_pipeline(image_path: image_path) do |pipeline|
        pipeline.pipeline_method
      end
    end

    it 'quality defined' do
      image_path = 'test_image_path.jpg'
      mock_pipeline = double(:image_processing_pipeline)
      allow(ImageProcessing::MiniMagick).to receive(:source).with(image_path).and_return(mock_pipeline)
      allow(mock_pipeline).to receive(:strip).and_return(mock_pipeline)
      expect(mock_pipeline).to receive(:saver).with(quality: 50).and_return(mock_pipeline)
      allow(mock_pipeline).to receive_message_chain(:convert, :call)
      Image.image_processing_pipeline(image_path: image_path, quality: 50)
    end
  end

  describe 'before_save' do
    describe '#process_image_attachment' do
      before(:each) do
        subject.image_file = image_file_upload
      end

      it 'image already processed' do
        allow(image_file_upload).to receive(:instance_of?).with(ActionDispatch::Http::UploadedFile).and_return(false)
        expect(subject).not_to receive(:process_and_reattach_image)
        subject.save
      end

      describe 'image not yet processed' do
        before(:each) do
          allow(image_file_upload).to receive(:instance_of?).with(ActionDispatch::Http::UploadedFile).and_return(true)
        end

        it 'validate image' do
          expect(Image).to receive(:valid?).and_return(false)
          expect(subject.save).to eq(false)
          expect(subject.errors.messages[:base]).to eq ["Image invalid, please upload a jpeg or png file!"]
        end

        it 'image processed' do
          mock_image_file = double(:image_file)
          allow(Image).to receive(:valid?).and_return(true)
          expect(subject).to receive(:process_image).and_return(image_jpg_path)
          allow(subject).to receive(:image_file).and_return(mock_image_file)
          expect(mock_image_file).to receive(:attach)
          subject.save
        end
      end
    end
  end
end

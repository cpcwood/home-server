# == Schema Information
#
# Table name: gallery_images
#
#  id          :bigint           not null, primary key
#  date_taken  :datetime
#  description :string           not null
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_gallery_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

RSpec.describe GalleryImage, type: :model do
  subject { create(:gallery_image) }

  let(:image_file_upload) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/jpg') }

  context 'validations' do
    describe 'date_taken' do
      it 'format' do
        subject.date_taken = nil
        expect(subject).to_not be_valid
        subject.date_taken = 'not an iso date'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:date_taken]).to eq ['Date taken must be date']
        subject.date_taken = DateTime.new(2020, 04, 19, 0, 0, 0)
        expect(subject).to be_valid
      end
    end

    describe 'latitude' do
      it 'type' do
        subject.latitude = 'not a number'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:latitude].first).to eq('Latitude must be a (10, 6) decimal')
      end

      it 'format' do
        subject.latitude = 1179.999999
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:latitude].first).to eq('Latitude must be a (10, 6) decimal')
        subject.latitude = nil
        expect(subject).to be_valid
        subject.latitude = 179.999999
        expect(subject).to be_valid
      end
    end

    describe 'longitude' do
      it 'type' do
        subject.longitude = 'not a number'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:longitude].first).to eq('Longitude must be a (10, 6) decimal')
      end

      it 'format' do
        subject.longitude = 1179.999999
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:longitude].first).to eq('Longitude must be a (10, 6) decimal')
        subject.longitude = nil
        expect(subject).to be_valid
        subject.longitude = 179.999999
        expect(subject).to be_valid
      end
    end
  end

  describe '#variant_sizes' do
    it 'default_value' do
      expect(subject.variant_sizes).to eq(GalleryImage::VARIANT_SIZES)
    end
  end

  describe 'before_validation' do
    describe '#set_defaults' do
      it 'no description' do
        gallery_image = create(:gallery_image, description: nil)
        expect(gallery_image.description).to eq('gallery-image')
      end
    end

    describe '#extract_meta_data' do
      it 'image already processed' do
        allow(image_file_upload).to receive(:instance_of?).with(ActionDispatch::Http::UploadedFile).and_return(false)
        allow(subject).to receive(:process_new_image_attachment).and_throw(:abort)
        expect(MiniMagick::Image).not_to receive(:new)
        subject.image_file = image_file_upload
        subject.save
      end

      describe 'image not yet processed' do
        before(:each) do
          allow(image_file_upload).to receive(:instance_of?).with(ActionDispatch::Http::UploadedFile).and_return(true)
          mini_magick_mock = double(:mini_magick, exif: {
                                      'DateTimeOriginal' => '2020:04:19 00:00',
                                      'GPSLatitude' => '1, 60, 3600',
                                      'GPSLatitudeRef' => 'N',
                                      'GPSLongitude' => '1, 60, 3600',
                                      'GPSLongitudeRef' => 'W'
                                    })
          allow(MiniMagick::Image).to receive(:new).and_return(mini_magick_mock)
          allow(subject).to receive(:process_new_image_attachment).and_throw(:abort)
          subject.image_file = image_file_upload
        end

        it 'date_taken attribute missing' do
          subject.date_taken = nil
          subject.save
          expect(subject.date_taken).to eq(DateTime.new(2020, 04, 19))
        end

        it 'latitude attribute missing' do
          subject.latitude = nil
          subject.save
          expect(subject.latitude).to eq(3)
        end

        it 'longitude attribute missing' do
          subject.longitude = nil
          subject.save
          expect(subject.longitude).to eq(-3)
        end
      end
    end
  end
end

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

  let(:image_path_valid) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_file_upload) { fixture_file_upload(image_path_valid, 'image/jpg') }

  context 'validations' do
    describe 'description' do
      it 'format' do
        subject.description = nil
        expect(subject).to_not be_valid
        subject.description = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:description]).to eq ['Description cannot be blank']
        subject.description = 'a'
        expect(subject).to be_valid
      end
    end

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

  context 'before_validation' do
    describe '#process_image_attachment' do
      before(:each) do
        subject
        allow(image_file_upload).to receive(:instance_of?).with(ActionDispatch::Http::UploadedFile).and_return(true)
      end

      it 'validate image' do
        expect(Image).to receive(:valid?).and_return(false)
        subject.image_file = image_file_upload
        expect(subject.save).to eq(false)
      end

      it 'resizes image' do
        expect(Image).to receive(:resize_to_max) do |image|
          image[:image_path]
        end
        subject.image_file = image_file_upload
        subject.save
      end

      it 'attributes missing - extract meta data' do
        subject.image_file = image_file_upload
        subject.date_taken = nil
        subject.latitude = nil
        subject.longitude = nil
        subject.save
        expect(subject.date_taken).to eq(DateTime.new(2020, 04, 19))
        expect(subject.latitude).to eq(1)
        expect(subject.longitude).to eq(-1)
      end
    end
  end
end

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
  end
end

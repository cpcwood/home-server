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
      it 'Length' do
        subject.description = nil
        expect(subject).to_not be_valid
        subject.description = ''
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:description]).to eq ['Description cannot be blank']
      end
    end

    describe 'date_taken' do
      it 'type' do
        subject.date_taken = nil
        expect(subject).to_not be_valid
        subject.date_taken = 'not a date'
        expect(subject).to_not be_valid
        expect(subject.errors.messages[:date_taken]).to eq ['Date taken must be date']
      end
    end
  end
end

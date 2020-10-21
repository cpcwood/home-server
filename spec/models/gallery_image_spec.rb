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
      it 'Presence' do
        subject.description = nil
        expect(subject).to_not be_valid
      end

      it 'Value' do
        subject.description = ''
        expect(subject).to_not be_valid
      end
    end
  end
end

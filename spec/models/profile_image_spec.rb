# == Schema Information
#
# Table name: profile_images
#
#  id          :bigint           not null, primary key
#  description :string
#  x_loc       :integer          default(50)
#  y_loc       :integer          default(50)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  about_id    :bigint
#
# Indexes
#
#  index_profile_images_on_about_id  (about_id)
#
# Foreign Keys
#
#  fk_rails_...  (about_id => abouts.id)
#

RSpec.describe ProfileImage, type: :model do
  subject { create(:profile_image) }

  describe '#x_dim' do
    it 'default_value' do
      expect(subject.x_dim).to eq(ProfileImage::X_DIM)
    end
  end

  describe '#y_dim' do
    it 'default_value' do
      expect(subject.y_dim).to eq(ProfileImage::Y_DIM)
    end
  end

  describe 'before_validation' do
    describe '#set_defaults' do
      it 'no description' do
        profile_image = create(:profile_image, description: nil)
        expect(profile_image.description).to eq('about-me-profile-image')
      end
    end
  end
end

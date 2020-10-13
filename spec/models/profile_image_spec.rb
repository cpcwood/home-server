# == Schema Information
#
# Table name: profile_images
#
#  id          :bigint           not null, primary key
#  description :string
#  x_loc       :integer          default(50)
#  y_loc       :integer          default(50)
#  about_id    :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

RSpec.describe ProfileImage, type: :model do
  describe 'before validation' do
    describe '#set_defaults' do
      it 'no description' do
        profile_image = ProfileImage.create
        expect(profile_image.description).to eq('about-me-profile-image')
      end
    end
  end
end

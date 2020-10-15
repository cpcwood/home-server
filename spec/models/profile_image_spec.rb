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
  describe 'before validation' do
    describe '#set_defaults' do
      it 'no description' do
        profile_image = create(:profile_image, description: nil)
        expect(profile_image.description).to_not be_nil
      end
    end
  end
end

# == Schema Information
#
# Table name: cover_images
#
#  id              :bigint           not null, primary key
#  description     :string
#  link            :string
#  x_loc           :integer          default(50)
#  y_loc           :integer          default(50)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  site_setting_id :bigint
#
# Indexes
#
#  index_cover_images_on_site_setting_id  (site_setting_id)
#
# Foreign Keys
#
#  fk_rails_...  (site_setting_id => site_settings.id)
#
RSpec.describe CoverImage, type: :model do
  subject { create(:cover_image) }

  describe '#default_image' do
    it 'default value' do
      expect(subject.default_image).to eq('default_images/default_cover_image.jpg')
    end
  end

  describe '#x_dim' do
    it 'default_value' do
      expect(subject.x_dim).to eq(CoverImage::X_DIM)
    end
  end

  describe '#y_dim' do
    it 'default_value' do
      expect(subject.y_dim).to eq(CoverImage::Y_DIM)
    end
  end
end

# == Schema Information
#
# Table name: project_images
#
#  id          :bigint           not null, primary key
#  description :string           default("project-image"), not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint           not null
#
# Indexes
#
#  index_project_images_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
RSpec.describe ProjectImage, type: :model do
  subject { create(:project_image) }

  describe '#variant_sizes' do
    it 'default_value' do
      expect(subject.variant_sizes).to eq(ProjectImage::VARIANT_SIZES)
    end
  end
end

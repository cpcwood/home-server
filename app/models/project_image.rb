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
class ProjectImage < Image
  VARIANT_SIZES = {
    thumbnail: { resize_to_limit: [700, 500] }
  }.freeze

  belongs_to :project

  def variant_sizes
    VARIANT_SIZES
  end

  def process_image(attached_image)
    Image.image_processing_pipeline(image_path: attached_image) do |pipeline|
      pipeline.resize_to_limit(MAX_DIM, MAX_DIM)
    end
  end
end

# == Schema Information
#
# Table name: project_images
#
#  id          :bigint           not null, primary key
#  description :string           default("project-image"), not null
#  order       :integer
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
  MAX_DIM = 2000

  VARIANT_SIZES = {
    thumbnail: { resize_to_limit: [1200, 850] }
  }.freeze

  belongs_to :project

  scope :order_asc, -> { order(order: :asc) }

  def variant_sizes
    VARIANT_SIZES
  end

  def process_image(attached_image)
    Image.image_processing_pipeline(image_path: attached_image, quality: 80) do |pipeline|
      pipeline.resize_to_limit(MAX_DIM, MAX_DIM)
    end
  end
end

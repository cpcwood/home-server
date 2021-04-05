# == Schema Information
#
# Table name: post_section_images
#
#  id              :bigint           not null, primary key
#  description     :string           default("post-image"), not null
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  post_section_id :bigint           not null
#
# Indexes
#
#  index_post_section_images_on_post_section_id  (post_section_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_section_id => post_sections.id)
#
class PostSectionImage < Image

  belongs_to :post_section

  before_save :assign_description_from_title

  MAX_DIM = 3000

  VARIANT_SIZES = {
    thumbnail: { resize_to_limit: [1000, 1000] }
  }.freeze

  def variant_sizes
    VARIANT_SIZES
  end

  private

  def process_image(attached_image)
    Image.image_processing_pipeline(image_path: attached_image, quality: 80) do |pipeline|
      pipeline.resize_to_limit(MAX_DIM, MAX_DIM)
    end
  end

  def assign_description_from_title
    self.description = self.title unless self.title.nil? || self.title&.blank?
  end
end

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
class ProfileImage < Image
  belongs_to :about

  X_DIM = 500
  Y_DIM = 500

  before_validation :set_defaults

  def set_defaults
    self.description ||= 'about-me-profile-image'
  end

  def x_dim
    X_DIM
  end

  def y_dim
    Y_DIM
  end

  private

  def process_image(attached_image)
    Image.image_processing_pipeline(image_path: attached_image) do |pipeline|
      pipeline.resize_to_fill(x_dim, y_dim, gravity: 'north-west')
    end
  end
end

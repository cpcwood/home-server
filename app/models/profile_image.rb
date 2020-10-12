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
end

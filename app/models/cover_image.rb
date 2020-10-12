# == Schema Information
#
# Table name: cover_images
#
#  id              :bigint           not null, primary key
#  link            :string
#  description     :string
#  x_loc           :integer          default(50)
#  y_loc           :integer          default(50)
#  site_setting_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class CoverImage < Image
  belongs_to :site_setting

  X_DIM = 1450
  Y_DIM = 680

  def default_image
    'default_images/default_cover_image.jpg'
  end

  def x_dim
    X_DIM
  end

  def y_dim
    Y_DIM
  end
end

# == Schema Information
#
# Table name: header_images
#
#  id              :bigint           not null, primary key
#  description     :string
#  x_loc           :integer          default(50)
#  y_loc           :integer          default(50)
#  site_setting_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class HeaderImage < Image
  belongs_to :site_setting

  X_DIM = 2560
  Y_DIM = 300

  def default_image
    'default_images/default_header_image.jpg'
  end

  def x_dim
    X_DIM
  end

  def y_dim
    Y_DIM
  end
end

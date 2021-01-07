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
class CoverImage < SiteImage
  X_DIM = 1100
  Y_DIM = 600

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

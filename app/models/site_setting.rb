class SiteSetting < ApplicationRecord
  include DefaultImageHelper

  has_one_attached :cover_image

  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }

  def update_required?(key, value)
    self[key] != value
  end

  def cover_image_path
    cover_image.attached? ? cover_image : default_cover_image_path
  end
end

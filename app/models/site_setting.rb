class SiteSetting < ApplicationRecord
  include DefaultImageHelper

  has_one_attached :header_image

  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }

  def update_required?(key, value)
    self[key] != value
  end

  def header_image_path
    header_image.attached? ? header_image : default_header_image_path
  end
end

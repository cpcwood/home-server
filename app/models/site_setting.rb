class SiteSetting < ApplicationRecord
  require 'mini_magick'

  has_many :images, dependent: :destroy

  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }

  validates :typed_header_enabled,
            inclusion: { in: [true, false] }

  def update_required?(key, value)
    self[key] != value
  end

  def cover_images
    images.where(image_type: 'cover_image').to_a
  end
end

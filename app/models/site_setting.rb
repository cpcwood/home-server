class SiteSetting < ApplicationRecord
  require 'mini_magick'

  has_many :images, dependent: :destroy

  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }

  validates :typed_header_enabled,
            inclusion: { in: [true, false] }

  validates :header_text,
            length: { maximum: 255, too_long: 'Header text cannot be longer than 255 charaters' }

  validates :subtitle_text,
            length: { maximum: 255, too_long: 'Subtitle text cannot be longer than 255 charaters' }

  def update_required?(attribute:, value:)
    self[attribute] != value
  end

  def cover_images
    images.where(image_type: 'cover_image').to_a
  end
end

class SiteSetting < ApplicationRecord
  has_one_attached :cover_image

  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }


  def update_required?(key, value)
    self[key] != value
  end
end

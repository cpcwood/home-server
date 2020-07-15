class SiteSetting < ApplicationRecord
  require 'mini_magick'

  has_many :images, dependent: :destroy

  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }

  def update_required?(key, value)
    self[key] != value
  end

  def images_hash
    images.index_by do |image|
      image.name.to_sym
    end
  end
end

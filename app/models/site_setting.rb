class SiteSetting < ApplicationRecord
  require 'mini_magick'

  has_many :images, dependent: :destroy

  has_one_attached :header_image
  has_one_attached :about_image
  has_one_attached :projects_image
  has_one_attached :blog_image
  has_one_attached :say_hello_image
  has_one_attached :gallery_image
  has_one_attached :contact_image

  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }

  def update_required?(key, value)
    self[key] != value
  end

  def self.image_valid?(image_path)
    image = MiniMagick::Image.new(image_path)
    image.valid? ? image.mime_type.match?(%r{\Aimage/(png|jpeg)\z}i) : false
  end
end

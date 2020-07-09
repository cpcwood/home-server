class SiteSetting < ApplicationRecord
  require 'mini_magick'

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

  def self.resize_image(image_path:, x_dim:, y_dim:)
    expanded_image = expand_image(image_path: image_path, x_dim: x_dim)
    resized_image = vertical_center_crop_image(image_path: expanded_image.path, y_dim: y_dim)
    remove_exif_data(resized_image.path)
  end

  def self.image_valid?(image_path)
    image = MiniMagick::Image.new(image_path)
    image.valid? ? image.mime_type.match?(%r{\Aimage/(png|jpeg)\z}i) : false
  end

  def self.expand_image(image_path:, x_dim: nil, y_dim: nil)
    ImageProcessing::MiniMagick.source(image_path).resize_to_fit(x_dim, y_dim).call
  end

  def self.vertical_center_crop_image(image_path:, x_dim: nil, y_dim: nil)
    dimensions = MiniMagick::Image.new(image_path).dimensions
    v_crop_start = (dimensions[1] - y_dim) / 2
    ImageProcessing::MiniMagick.source(image_path).crop(0, v_crop_start, x_dim, y_dim).call
  end

  def self.remove_exif_data(image_path)
    ImageProcessing::MiniMagick.source(image_path).strip.call
  end
end

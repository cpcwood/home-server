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

  def self.resize_header_image(image_path:, x_dim:, y_dim:)
    expanded_image = expand_image(image_path: image_path, x_dim: x_dim)
    resized_image = vertical_center_crop_image(image_path: expanded_image.path, y_dim: y_dim)
    remove_exif_data(resized_image.path)
  end

  def self.image_valid?(image_path)
    image = MiniMagick::Image.new(image_path)
    if image.valid?
      image.mime_type.match?(/\Aimage\/(png|jpeg)\z/i)
    else
      false
    end
  end

  private

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
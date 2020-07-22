class Image < ApplicationRecord
  require 'image_processing'

  DEFAULT_X_LOC = 50
  DEFAULT_Y_LOC = 50

  belongs_to :site_setting

  has_one_attached :image_file

  validates :name,
            length: { in: 1..255, too_short: 'Image name cannot be blank', too_long: 'Image name cannot be longer than 255 charaters' }

  validates :x_dim,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :y_dim,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :x_loc,
            presence: true,
            numericality: { only_integer: true, greater_than: -1, less_than: 101 }

  validates :y_loc,
            presence: true,
            numericality: { only_integer: true, greater_than: -1, less_than: 101 }

  def reset_to_default
    image_file.purge
    update(x_loc: DEFAULT_X_LOC)
    update(y_loc: DEFAULT_Y_LOC)
  end

  def self.valid?(image_path)
    image = MiniMagick::Image.new(image_path)
    image.valid? ? image.mime_type.match?(%r{\Aimage/(png|jpeg)\z}i) : false
  end

  def self.resize(image_path:, x_dim:, y_dim:)
    expanded_image = expand_image(image_path: image_path, x_dim: x_dim)
    resized_image = vertical_center_crop_image(image_path: expanded_image.path, y_dim: y_dim)
    remove_exif_data(resized_image.path)
  end

  private_class_method def self.expand_image(image_path:, x_dim: nil, y_dim: nil)
    ImageProcessing::MiniMagick.source(image_path).resize_to_fit(x_dim, y_dim).call
  end

  private_class_method def self.vertical_center_crop_image(image_path:, x_dim: nil, y_dim: nil)
    dimensions = MiniMagick::Image.new(image_path).dimensions
    v_crop_start = (dimensions[1] - y_dim) / 2
    ImageProcessing::MiniMagick.source(image_path).crop(0, v_crop_start, x_dim, y_dim).call
  end

  private_class_method def self.remove_exif_data(image_path)
    ImageProcessing::MiniMagick.source(image_path).strip.call
  end
end
class Image < ApplicationRecord
  self.abstract_class = true

  require 'image_processing'

  DEFAULT_X_LOC = 50
  DEFAULT_Y_LOC = 50

  has_one_attached :image_file

  validates :x_loc,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :y_loc,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :description,
            presence: true,
            length: { minimum: 1 }

  def reset_to_default
    image_file.purge
    update(x_loc: DEFAULT_X_LOC)
    update(y_loc: DEFAULT_Y_LOC)
  end

  def custom_style
    "object-position: #{x_loc}% #{y_loc}%;" if x_loc != DEFAULT_X_LOC || y_loc != DEFAULT_Y_LOC
  end

  def attach_image(upload_params)
    image_file_path = upload_params.tempfile.path
    unless Image.valid?(image_file_path)
      errors[:base].push("#{description.humanize} invalid, please upload a jpeg or png file!")
      return false
    end
    modified_image = Image.resize(image_path: image_file_path, x_dim: x_dim, y_dim: y_dim)
    image_file.attach(
      io: File.open(modified_image),
      filename: upload_params.original_filename,
      content_type: upload_params.content_type)
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

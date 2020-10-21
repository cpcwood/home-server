class Image < ApplicationRecord
  require 'image_processing'

  self.abstract_class = true

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

  before_save :process_image_attachment

  def reset_to_default
    image_file.purge_later
    update(x_loc: DEFAULT_X_LOC, y_loc: DEFAULT_Y_LOC)
  end

  def custom_style
    "object-position: #{x_loc}% #{y_loc}%;" if x_loc != DEFAULT_X_LOC || y_loc != DEFAULT_Y_LOC
  end

  def change_messages
    messages = []
    messages += (previous_changes.keys - ['updated_at'])
    messages.map!{ |key| "#{description.humanize.gsub('-', ' ')} #{key.humanize(capitalize: false)} updated!" }
    messages.push("#{description.humanize.gsub('-', ' ')} updated!") if image_file&.attachment&.blob&.previous_changes&.any?
    messages
  end

  def self.valid?(image_path)
    image = MiniMagick::Image.new(image_path)
    image.valid? ? image.mime_type.match?(%r{\Aimage/(png|jpeg)\z}i) : false
  end

  def self.resize_and_fill(image_path:, x_dim:, y_dim:)
    pipeline = initalize_image(image_path)
    pipeline = resize_and_crop(pipeline: pipeline, x_dim: x_dim, y_dim: y_dim)
    pipeline = pipeline.strip
    pipeline = convert(pipeline)
    pipeline.call
  end

  def self.resize_to_max(image_path:, max_dim:)
    pipeline = initalize_image(image_path)
    pipeline = pipeline.resize_to_limit(max_dim, max_dim)
    pipeline = pipeline.strip
    pipeline = convert(pipeline)
    pipeline.call
  end

  private

  def process_image_attachment
    image_upload = attachment_changes['image_file']
    attach_image(image_upload.attachable) if image_upload&.attachable.instance_of?(ActionDispatch::Http::UploadedFile)
  end

  def attach_image(upload_params)
    image_file_path = upload_params.tempfile.path
    unless Image.valid?(image_file_path)
      errors[:base].push("#{description.humanize} invalid, please upload a jpeg or png file!")
      throw(:abort)
    end
    modified_image = Image.resize_and_fill(image_path: image_file_path, x_dim: x_dim, y_dim: y_dim)
    image_file.attach(
      io: File.open(modified_image),
      filename: upload_params.original_filename,
      content_type: upload_params.content_type)
  end

  private_class_method def self.initalize_image(image_path)
    ImageProcessing::MiniMagick.source(image_path)
  end

  private_class_method def self.resize_and_crop(pipeline:, x_dim:, y_dim:)
    pipeline.resize_to_fill(x_dim, y_dim, gravity: 'north-west')
  end

  private_class_method def self.convert(pipeline)
    pipeline
      .saver(quality: 85)
      .convert('jpg')
  end
end

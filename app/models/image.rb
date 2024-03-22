class Image < ApplicationRecord
  require 'image_processing'
  require 'mini_magick'

  self.abstract_class = true

  has_one_attached :image_file

  validates :description,
            length: { minimum: 1, message: 'Description cannot be blank' }

  before_save :process_new_image_attachment
  after_commit :process_variants

  def change_messages
    messages = []
    messages += (previous_changes.keys - ['updated_at'])
    messages.map!{ |key| "#{description.humanize.tr('-', ' ')} #{key.humanize(capitalize: false)} updated!" }
    messages.push("#{description.humanize.tr('-', ' ')} updated!") if image_file&.attachment&.blob&.previous_changes&.any?
    messages
  end

  def process_new_image_attachment
    image_upload = attachment_changes['image_file']
    return unless image_upload&.attachable.instance_of?(ActionDispatch::Http::UploadedFile)
    process_and_reattach_image(image_upload.attachable)
  end

  def process_variants
    return unless attachment_changes['image_file']
    return unless respond_to?(:variant_sizes)
    variant_sizes&.each_value do |process|
      ProcessImageVariantJob.set(wait: 5.seconds).perform_later(model: self, variant: process)
    end
  end

  def self.valid?(image_path)
    image = MiniMagick::Image.new(image_path)
    return false unless image.mime_type.match?(%r{\Aimage/(png|jpeg)\z}i)
    image.valid?
  end

  def self.image_processing_pipeline(image_path:, quality: 60)
    pipeline = initalize_image(image_path)
    pipeline = yield(pipeline) if block_given?
    pipeline
      .strip
      .saver(quality: quality)
      .convert('jpg')
      .call
  end

  private

  def process_and_reattach_image(image_attachment)
    validate_image(image_attachment)
    processed_image_file = process_image(image_attachment)
    image_file.attach(
      io: File.open(processed_image_file),
      filename: image_attachment.original_filename,
      content_type: image_attachment.content_type)
  end

  def validate_image(image_attachment)
    return if Image.valid?(image_attachment.tempfile.path)
    errors.add(:base, :blank, message: 'Image invalid, please upload a jpeg or png file!')
    throw(:abort)
  end

  private_class_method def self.initalize_image(image_path)
    ImageProcessing::MiniMagick.source(image_path)
  end
end

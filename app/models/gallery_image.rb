# == Schema Information
#
# Table name: gallery_images
#
#  id          :bigint           not null, primary key
#  date_taken  :datetime
#  description :string           not null
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_gallery_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class GalleryImage < ApplicationRecord
  require 'image_processing'
  require 'mini_magick'

  MAX_DIM = 3000

  belongs_to :user

  has_one_attached :image_file

  validates :description,
            length: {
              minimum: 1,
              message: 'Description cannot be blank'
            }

  validates :date_taken,
            timeliness: {
              message: 'Date taken must be date'
            }

  validates :latitude,
            numericality: {
              allow_nil: true,
              message: 'Latitude must be a (10, 6) decimal'
            },
            format: {
              allow_nil: true,
              with: /\A[+-]?\d{1,3}\.\d{0,7}\z/,
              message: 'Latitude must be a (10, 6) decimal'
            }

  validates :longitude,
            numericality: {
              allow_nil: true,
              message: 'Longitude must be a (10, 6) decimal'
            },
            format: {
              allow_nil: true,
              with: /\A[+-]?\d{1,3}\.\d{0,7}\z/,
              message: 'Longitude must be a (10, 6) decimal'
            }

  before_validation :process_image_attachment

  def process_image_attachment
    image_upload = attachment_changes['image_file']
    attach_image(image_upload.attachable) if image_upload&.attachable.instance_of?(ActionDispatch::Http::UploadedFile)
  end

  private

  def attach_image(upload_params)
    image_file_path = upload_params.tempfile.path
    unless Image.valid?(image_file_path)
      errors[:base].push('Image invalid, please upload a jpeg or png file!')
      throw(:abort)
    end
    extract_meta_data(image_file_path)
    processed_image = Image.resize_to_max(image_path: image_file_path, max_dim: MAX_DIM)
    image_file.attach(
      io: File.open(processed_image),
      filename: upload_params.original_filename,
      content_type: upload_params.content_type)
  end

  def extract_meta_data(image_file_path)
    image_meta_data = MiniMagick::Image.new(image_file_path).exif
    extract_date_taken(image_meta_data)
    extract_latitude(image_meta_data)
    extract_longitude(image_meta_data)
  end

  def extract_date_taken(image_meta_data)
    return unless date_taken.blank? && image_meta_data['DateTimeOriginal']
    self.date_taken = DateTime.parse(image_meta_data['DateTimeOriginal'].gsub(':', '-'))
  end

  def extract_latitude(image_meta_data)
    return unless latitude.blank? && image_meta_data['GPSLatitude'] && image_meta_data['GPSLatitudeRef']
    self.latitude = parse_exif_dms(coordinate: image_meta_data['GPSLatitude'], ref: image_meta_data['GPSLatitudeRef'])
  end

  def extract_longitude(image_meta_data)
    return unless longitude.blank? && image_meta_data['GPSLongitude'] && image_meta_data['GPSLongitudeRef']
    self.longitude = parse_exif_dms(coordinate: image_meta_data['GPSLongitude'], ref: image_meta_data['GPSLongitudeRef'])
  end

  def parse_exif_dms(coordinate:, ref:)
    d, m, s = coordinate.split(', ').map(&:to_r)
    dd = d + m / 60 + s / 3600
    dd *= -1 if %w[S W].include?(ref)
    dd
  end
end
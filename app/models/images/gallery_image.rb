# == Schema Information
#
# Table name: gallery_images
#
#  id          :bigint           not null, primary key
#  date_taken  :datetime
#  description :string           not null
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  title       :string
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
class GalleryImage < Image
  require 'mini_magick'

  MAX_DIM = 3000

  VARIANT_SIZES = {
    thumbnail: { resize_to_limit: [700, 500] }
  }.freeze

  belongs_to :user

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

  before_validation :extract_meta_data, :set_defaults

  def variant_sizes
    VARIANT_SIZES
  end

  private

  def set_defaults
    self.description ||= 'gallery-image'
    self.date_taken ||= DateTime.current
  end

  def process_image(attached_image)
    Image.image_processing_pipeline(image_path: attached_image, quality: 80) do |pipeline|
      pipeline.resize_to_limit(MAX_DIM, MAX_DIM)
    end
  end

  def extract_meta_data
    image_upload = attachment_changes['image_file']
    return unless image_upload&.attachable.instance_of?(ActionDispatch::Http::UploadedFile)
    image_meta_data = MiniMagick::Image.new(image_upload.attachable.tempfile.path).exif
    extract_date_taken(image_meta_data)
    extract_gps_coordinates(image_meta_data)
  end

  def extract_date_taken(image_meta_data)
    return unless date_taken.blank? && image_meta_data['DateTimeOriginal']
    begin
      self.date_taken = DateTime.parse(image_meta_data['DateTimeOriginal'].tr(':', '-'))
    rescue StandardError
      self.date_taken = nil
    end
  end

  def extract_gps_coordinates(image_meta_data)
    return unless longitude.blank? && latitude.blank? && image_meta_data['GPSLatitude'] && image_meta_data['GPSLatitudeRef']
    begin
      self.latitude = parse_exif_dms(coordinate: image_meta_data['GPSLatitude'], ref: image_meta_data['GPSLatitudeRef'])
      self.longitude = parse_exif_dms(coordinate: image_meta_data['GPSLongitude'], ref: image_meta_data['GPSLongitudeRef'])
    rescue StandardError
      self.latitude = nil
      self.longitude = nil
    end
  end

  def parse_exif_dms(coordinate:, ref:)
    d, m, s = coordinate.split(', ').map(&:to_r)
    dd = d + (m / 60) + (s / 3600)
    dd *= -1 if %w[S W].include?(ref)
    dd
  end
end

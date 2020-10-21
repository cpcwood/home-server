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

  before_save :process_image_attachment

  private

  def process_image_attachment
    image_upload = attachment_changes['image_file']
    attach_image(image_upload.attachable) if image_upload&.attachable.instance_of?(ActionDispatch::Http::UploadedFile)
  end

  def attach_image(upload_params)
    image_file_path = upload_params.tempfile.path
    unless Image.valid?(image_file_path)
      errors[:base].push('Image invalid, please upload a jpeg or png file!')
      throw(:abort)
    end
  end
end
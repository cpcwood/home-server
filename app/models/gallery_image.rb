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
end
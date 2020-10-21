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

  validates :description,
            presence: true,
            length: { minimum: 1 }
end

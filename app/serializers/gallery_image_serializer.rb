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
class GalleryImageSerializer
  include JSONAPI::Serializer
  extend AttachmentHelper

  attributes :title, :description

  attribute :thumbnail_url do |gallery_image|
    fetch_image_url(image_model: gallery_image, variant: :thumbnail)
  end

  attribute :url do |gallery_image|
    fetch_image_url(image_model: gallery_image)
  end
end

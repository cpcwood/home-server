class About < ApplicationRecord
  has_one :profile_image, dependent: :destroy
end

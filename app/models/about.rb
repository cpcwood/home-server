class About < ApplicationRecord
  has_one :image, dependent: :destroy
end

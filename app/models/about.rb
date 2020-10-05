class About < ApplicationRecord
  has_one :images, dependent: :destroy
end

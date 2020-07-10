class Image < ApplicationRecord
  belongs_to :site_setting

  validates :name,
            length: { in: 1..255, too_short: 'Image name cannot be blank', too_long: 'Image name cannot be longer than 255 charaters' }
end

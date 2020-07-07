class SiteSetting < ApplicationRecord
  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }
end

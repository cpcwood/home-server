class SiteSetting < ApplicationRecord
  require 'mini_magick'

  has_one :header_image, dependent: :destroy
  has_many :cover_images, dependent: :destroy

  validates :name,
            length: { in: 1..255, too_short: 'Site name cannot be blank', too_long: 'Site name cannot be longer than 255 charaters' }

  validates :typed_header_enabled,
            inclusion: { in: [true, false] }

  validates :header_text,
            length: { maximum: 255, too_long: 'Header text cannot be longer than 255 charaters' }

  validates :subtitle_text,
            length: { maximum: 255, too_long: 'Subtitle text cannot be longer than 255 charaters' }

  def change_messages
    messages = []
    messages += (previous_changes.keys - ['updated_at'])
    messages.map!{ |key| "#{key.humanize} updated!" }
  end
end

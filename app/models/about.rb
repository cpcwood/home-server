# == Schema Information
#
# Table name: abouts
#
#  id            :bigint           not null, primary key
#  about_me      :text
#  github_link   :string
#  linkedin_link :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class About < ApplicationRecord
  has_one :profile_image, dependent: :destroy
  accepts_nested_attributes_for :profile_image, allow_destroy: true

  def change_messages
    messages = []
    messages += (previous_changes.keys - ['updated_at'])
    messages.map!{ |key| "#{key.humanize} updated!" }
    messages.push('Profile image updated!') if profile_image&.change_messages&.any?
    messages
  end
end

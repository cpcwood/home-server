# == Schema Information
#
# Table name: abouts
#
#  id            :bigint           not null, primary key
#  about_me      :text
#  contact_email :string           not null
#  github_link   :string
#  linkedin_link :string
#  location      :string           not null
#  name          :string           not null
#  section_title :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class About < ApplicationRecord
  has_one :profile_image, dependent: :destroy
  accepts_nested_attributes_for :profile_image, allow_destroy: true

  validates :linkedin_link,
            url: { allow_blank: true, message: 'Linkedin link is not valid' }

  validates :github_link,
            url: { allow_blank: true, message: 'Github link is not valid' }

  validates :name,
            length: { minimum: 1, message: 'Name cannot be blank' }

  validates :location,
            length: { minimum: 1, message: 'Location cannot be blank' }

  validates :contact_email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Email must be valid format' }

  validates_associated :profile_image

  def change_messages
    messages = []
    messages += (previous_changes.keys - ['updated_at'])
    messages.map!{ |key| "#{key.humanize} updated!" }
    messages.push('Profile image updated!') if profile_image&.change_messages&.any?
    messages
  end

  def footer_links
    {
      github_link: github_link,
      linkedin_link: linkedin_link
    }
  end
end

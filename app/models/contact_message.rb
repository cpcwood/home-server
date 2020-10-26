# == Schema Information
#
# Table name: contact_messages
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  email      :string           not null
#  from       :string           not null
#  subject    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ContactMessage < ApplicationRecord

  validates :from,
            length: { minimum: 1, message: 'From field cannot be blank' }
            
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Email must be valid' }
end

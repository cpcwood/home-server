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
#  user_id    :bigint
#
# Indexes
#
#  index_contact_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ContactMessage < ApplicationRecord
  belongs_to :user

  validates :from,
            length: { minimum: 1, message: 'From field cannot be blank' }

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Email must be valid' }

  validates :subject,
            length: { minimum: 1, message: 'Subject cannot be blank' }

  validates :content,
            length: { minimum: 1, message: 'Content cannot be blank' }

  before_validation :sanitize_inputs
  after_commit :send_contact_message

  def sanitize_inputs
    self.from = sanitize(from)
    self.email = sanitize(email)
    self.subject = sanitize(subject)
    self.content = sanitize(content)
  end

  def send_contact_message
    NewContactMessageJob.perform_later(contact_message: self)
  end

  private

  def sanitize(string)
    ActionView::Base.full_sanitizer.sanitize(string)
  end
end

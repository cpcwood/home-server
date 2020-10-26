class NewContactMessageJob < ApplicationJob
  queue_as :default

  def perform(contact_message:, user:)
    ContactMessageMailer.with(message: contact_message, to: user).send_contact_message.deliver_now
  end
end

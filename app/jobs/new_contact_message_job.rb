class NewContactMessageJob < ApplicationJob
  queue_as :default

  def perform(contact_message:)
    ContactMessageMailer.with(message: contact_message).send_contact_message.deliver_now
  end
end

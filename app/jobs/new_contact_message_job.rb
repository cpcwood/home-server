class NewContactMessageJob < ApplicationJob
  queue_as :default

  def perform(contact_message:)
    ContactMessageMailer.with(message: contact_message, deliver_to: About.first.contact_email).contact_message.deliver_now
    ContactMessageMailer.with(message: contact_message).confirmation.deliver_now
  end
end

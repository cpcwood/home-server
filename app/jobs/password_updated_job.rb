class PasswordUpdatedJob < ApplicationJob
  queue_as :default

  def perform(user:)
    user.send_password_updated_email!
  end
end

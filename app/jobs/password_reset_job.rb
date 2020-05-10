class PasswordResetJob < ApplicationJob
  queue_as :default

  def perform(email:)
    user = User.find_by(email: email)
    user&.send_password_reset_email!
  end
end

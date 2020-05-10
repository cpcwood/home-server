class User < ApplicationRecord
  has_secure_password

  def send_password_reset_email!
    generate_hashed_token
    PasswordMailer.with(user: self).password_reset_email.deliver_now
  end

  private

  def generate_hashed_token
    self.password_reset_token = SecureRandom.urlsafe_base64(32)
    self.password_reset_expiry = Time.zone.now + 1.hour
  end
end
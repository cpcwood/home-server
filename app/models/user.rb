class User < ApplicationRecord
  has_secure_password

  def send_password_reset_email!
    generate_hashed_token
    PasswordMailer.with(user: self).password_reset_email.deliver_now
  end

  def self.user_from_password_reset_token(token)
    return unless (reset_user = User.find_by(password_reset_token: token))
    reset_user if reset_user.password_reset_expiry > Time.zone.now
  end

  private

  def generate_hashed_token
    update(password_reset_token: SecureRandom.urlsafe_base64(32))
    update(password_reset_expiry: Time.zone.now + 1.hour)
  end
end
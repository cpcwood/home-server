class User < ApplicationRecord
  has_secure_password
  after_initialize :add_defaults

  validates :password,
            presence: true,
            length: { minimum: 8, too_short: 'The password must have at least 8 characters' },
            confirmation: { message: 'Passwords do not match' }

  def send_password_reset_email!
    generate_hashed_token
    PasswordMailer.with(user: self).password_reset_email.deliver_now
  end

  def self.user_from_password_reset_token(token)
    return unless token
    return unless (reset_user = User.find_by(password_reset_token: token))
    reset_user if reset_user.password_reset_expiry > Time.zone.now
  end

  def remove_password_reset!
    update(password_reset_token: nil)
    update(password_reset_expiry: nil)
  end

  def send_password_updated_email!
    PasswordMailer.with(user: self).password_updated_email.deliver_now
  end

  private

  def add_defaults
    self.last_login_time ||= Time.zone.now
    self.last_login_ip ||= '127.0.0.1'
  end

  def generate_hashed_token
    unique_token = loop do
      token = SecureRandom.urlsafe_base64(32)
      break token unless User.exists?(password_reset_token: token)
    end
    update(password_reset_token: unique_token)
    update(password_reset_expiry: Time.zone.now + 1.hour)
  end
end
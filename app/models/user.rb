require 'bcrypt'

class User < ApplicationRecord
  has_secure_password

  def generate_password_reset_token!
    self.password_reset_token = generate_hashed_token
    self.password_reset_expiry = Time.zone.now + 1.hour
  end

  private

  def generate_hashed_token
    BCrypt::Password.create(SecureRandom.urlsafe_base64(32))
  end
end

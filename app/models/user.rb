class User < ApplicationRecord
  has_secure_password validations: false
  after_initialize :add_defaults
  before_validation :convert_mobile_number, if: :mobile_number_changed?

  validates :password,
            presence: true,
            length: { minimum: 8, too_short: 'The password must have at least 8 characters' },
            confirmation: { message: 'Passwords do not match' },
            if: -> { new_record? || !password.nil? }

  validates :username,
            presence: true,
            uniqueness: { message: 'Username already taken' },
            format: { with: /\A[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*\z/, message: 'Only standard charaters and [ _-] are allowed' },
            confirmation: { message: 'Usernames do not match' },
            if: -> { new_record? || !username.nil? }

  validates :email,
            presence: true,
            uniqueness: { message: 'Email address already taken' },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Email must be valid format' },
            confirmation: { message: 'Emails do not match' },
            if: -> { new_record? || !email.nil? }

  validates :mobile_number,
            uniqueness: { message: 'Mobile phone numbers already taken' },
            format: { with: /\A(\+44|0)7\d{9}\z/, message: 'Please enter valid UK mobile phone number' },
            confirmation: { message: 'Mobile phone numbers do not match' },
            if: -> { !mobile_number.nil? }

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

  def convert_mobile_number
    self.mobile_number = mobile_number.sub(/\A(0)(7\d{9})\z/, '+44\2')
    self.mobile_number_confirmation = mobile_number_confirmation.sub(/\A(0)(7\d{9})\z/, '+44\2') if mobile_number_confirmation
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
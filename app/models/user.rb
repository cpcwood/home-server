# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  current_login_ip      :string
#  current_login_time    :datetime
#  email                 :text
#  last_login_ip         :string
#  last_login_time       :datetime
#  mobile_number         :text
#  password_digest       :text
#  password_reset_expiry :datetime
#  password_reset_token  :string
#  username              :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_users_on_email          (email) UNIQUE
#  index_users_on_mobile_number  (mobile_number) UNIQUE
#  index_users_on_username       (username) UNIQUE
#
class User < ApplicationRecord
  DEFAULT_REMOTE_IP = '127.0.0.1'.freeze

  has_many :posts, dependent: :destroy

  has_secure_password validations: false
  after_initialize :add_defaults
  after_validation :convert_mobile_number, if: -> { :mobile_number_changed? && !mobile_number.nil? }
  after_save :remove_password_reset

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

  def send_password_updated_email!
    PasswordMailer.with(user: self).password_updated_email.deliver_now
  end

  def convert_mobile_number
    self.mobile_number = mobile_number.sub(/\A(0)(7\d{9})\z/, '+44\2')
    self.mobile_number_confirmation = mobile_number_confirmation.sub(/\A(0)(7\d{9})\z/, '+44\2') if mobile_number_confirmation
  end

  def record_ip(request)
    update({
             last_login_time: current_login_time,
             last_login_ip: current_login_ip,
             current_login_time: Time.zone.now,
             current_login_ip: request.remote_ip
           })
  end

  private

  def add_defaults
    self.last_login_time ||= Time.zone.now
    self.last_login_ip ||= DEFAULT_REMOTE_IP
  end

  def remove_password_reset
    update(password_reset_token: nil, password_reset_expiry: nil) if previous_changes.keys.include?('password_digest') && password_reset_token && password_reset_expiry
  end

  def generate_hashed_token
    unique_token = loop do
      token = SecureRandom.urlsafe_base64(32)
      break token unless User.exists?(password_reset_token: token)
    end
    update(password_reset_token: unique_token, password_reset_expiry: Time.zone.now + 1.hour)
  end
end

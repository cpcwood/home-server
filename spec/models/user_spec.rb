require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    allow(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
  end

  describe 'Password validations' do
    it 'Rejects passwords less than 8 charaters' do
      @test_user.password = 'passwor'
      @test_user.password_confirmation = 'passwor'
      expect(@test_user).to_not be_valid
      expect(@test_user.errors.messages[:password]).to eq ['The password must have at least 8 characters']
    end

    it 'Accepts passwords with 8 or more charaters' do
      @test_user.password = 'newpassw'
      @test_user.password_confirmation = 'newpassw'
      expect(@test_user).to be_valid
    end

    it 'Requires a password confirmation' do
      @test_user.password = 'newpassw'
      @test_user.password_confirmation = ''
      expect(@test_user).to_not be_valid
    end
  end

  describe 'Username validations' do
    it 'Rejects blank usernames' do
      user = User.create(username: '', password: 'password', email: 'example@example.com', mobile_number: '+447234567890')
      expect(user).to_not be_valid
    end

    it 'Rejects invalid username formats' do
      user = User.create(username: ' example', password: 'password', email: 'example@example.com', mobile_number: '+447234567890')
      expect(user).to_not be_valid
      user = User.create(username: 'example ', password: 'password', email: 'example2@example.com', mobile_number: '+447234567891')
      expect(user).to_not be_valid
      user = User.create(username: 'e@xample', password: 'password', email: 'example3example.com', mobile_number: '+447234567892')
      expect(user).to_not be_valid
    end

    it 'Accepts valid username formats' do
      user = User.create(username: 'e', password: 'password', email: 'example@example.com', mobile_number: '+447234567890')
      expect(user).to be_valid
      user = User.create(username: 'exa mple', password: 'password', email: 'example2@example.com', mobile_number: '+447234567891')
      expect(user).to be_valid
      user = User.create(username: 'exa-mple example', password: 'password', email: 'example3@example.com', mobile_number: '+447234567892')
      expect(user).to be_valid
    end

    it 'Username must be unique' do
      user = User.create(username: 'example', password: 'password', email: 'example@example.com', mobile_number: '+447234567890')
      expect(user).to be_valid
      user = User.create(username: 'example', password: 'password', email: 'example2@example.com', mobile_number: '+447234567891')
      expect(user).to_not be_valid
    end

    it 'Requires confirmation for change' do
      @test_user.username = 'new-username'
      @test_user.username_confirmation = ''
      expect(@test_user).to_not be_valid
      @test_user.username_confirmation = 'new-username'
      expect(@test_user).to be_valid
    end
  end

  describe 'Email validations' do
    it 'Accepts valid emails' do
      @test_user.email = 'new@example.com'
      expect(@test_user).to be_valid
      @test_user.email = 'ad_m.in@exam-ple.co.uk'
      expect(@test_user).to be_valid
    end

    it 'Rejects emails with incorrect format' do
      @test_user.email = '@example.com'
      expect(@test_user).to_not be_valid
      @test_user.email = 'example.com'
      expect(@test_user).to_not be_valid
      @test_user.email = 'admin@'
      expect(@test_user).to_not be_valid
      @test_user.email = 'admin'
      expect(@test_user).to_not be_valid
    end

    it 'Rejects emails with invalid charaters' do
      @test_user.email = '\#@example.com'
      expect(@test_user).to_not be_valid
      expect(@test_user.errors.messages[:email]).to eq ['Email must be valid format']
    end

    it 'Email must be unique' do
      user = User.create(email: 'example@example.com', username: 'example', password: 'password', mobile_number: '+447234567890')
      expect(user).to be_valid
      user = User.create(email: 'example@example.com', username: 'example2', password: 'password', mobile_number: '+447234567891')
      expect(user).to_not be_valid
    end

    it 'Requires confirmation for change' do
      @test_user.email = 'new@example.com'
      @test_user.email_confirmation = ''
      expect(@test_user).to_not be_valid
      @test_user.email_confirmation = 'new@example.com'
      expect(@test_user).to be_valid
    end
  end

  describe 'Password validations' do
    it 'Rejects non-unique mobile numbers' do
      used_mobile_number = @test_user.mobile_number
      user = User.create(username: 'example', password: 'password', email: 'example@example.com', mobile_number: used_mobile_number)
      expect(user).to_not be_valid
    end
  end

  describe '#send_password_reset_email!' do
    it 'Adds a password reset token to user' do
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('testtoken')
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_token).to eq('testtoken')
    end

    it 'Password reset token is unique user' do
      User.create(username: 'another_user', password: 'password', email: 'email@example.com', password_reset_token: 'not_unique_token', mobile_number: '+447234567890')
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('not_unique_token', 'unique_token')
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_token).to eq('unique_token')
    end

    it 'Adds a password reset expiry to user' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_expiry).to eq(Time.zone.now + 1.hour)
    end

    it 'Password reset email requested to be sent' do
      expect(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
      @test_user.send_password_reset_email!
    end
  end

  describe '.user_from_password_reset_token' do
    it 'Returns user if reset token matches and in date' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      @test_user.update_attribute(:password_reset_token, 'test-token')
      @test_user.update_attribute(:password_reset_expiry, Time.zone.now + 1.hour)
      travel_to Time.zone.local(2020, 04, 19, 00, 59, 00)
      expect(User.user_from_password_reset_token('test-token')).to eq(@test_user)
    end

    it 'Returns nil if reset token matches and but not in date' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      @test_user.update_attribute(:password_reset_token, 'test-token')
      @test_user.update_attribute(:password_reset_expiry, Time.zone.now + 1.hour)
      travel_to Time.zone.local(2020, 04, 19, 01, 01, 00)
      expect(User.user_from_password_reset_token('test-token')).to eq(nil)
    end

    it 'Returns nil if reset token invalid' do
      @test_user.update_attribute(:password_reset_token, 'test-token')
      expect(User.user_from_password_reset_token('not_valid')).to eq(nil)
    end

    it 'Returns nil if reset token no present' do
      expect(User.user_from_password_reset_token(nil)).to eq(nil)
    end
  end

  describe '#remove_password_reset!' do
    it 'Removes password reset token' do
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_token).not_to eq(nil)
      @test_user.remove_password_reset!
      expect(@test_user.password_reset_token).to eq(nil)
    end

    it 'Removes password reset expiry' do
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_expiry).not_to eq(nil)
      @test_user.remove_password_reset!
      expect(@test_user.password_reset_expiry).to eq(nil)
    end
  end

  describe '#send_password_updated_email!' do
    it 'Password updated email sent to user' do
      expect(PasswordMailer).to receive_message_chain(:with, :password_updated_email, :deliver_now)
      @test_user.send_password_updated_email!
    end
  end
end

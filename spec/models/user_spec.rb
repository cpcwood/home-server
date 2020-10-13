# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  email                 :text
#  username              :text
#  password_digest       :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  mobile_number         :text
#  password_reset_token  :string
#  password_reset_expiry :datetime
#  last_login_ip         :string
#  last_login_time       :datetime
#  current_login_ip      :string
#  current_login_time    :datetime
#

RSpec.describe User, type: :model do
  subject { create(:user) }
  let(:user2) { create(:user2) }

  before(:each) do
    allow(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
  end

  describe 'Password validations' do
    it 'Rejects passwords less than 8 charaters' do
      subject.password = 'passwor'
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:password]).to eq ['The password must have at least 8 characters']
    end

    it 'Accepts passwords with 8 or more charaters' do
      subject.password = 'newpassw'
      expect(subject).to be_valid
    end

    it 'Requires a password confirmation if present' do
      subject.password = 'newpassw'
      subject.password_confirmation = ''
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:password_confirmation].last).to eq 'Passwords do not match'
      subject.password_confirmation = 'newpassw'
      expect(subject).to be_valid
    end
  end

  describe 'Username validations' do
    it 'Rejects blank usernames' do
      subject.username = ''
      expect(subject).to_not be_valid
    end

    it 'Rejects invalid username formats' do
      subject.username = ' example'
      expect(subject).to_not be_valid
      subject.username = 'example '
      expect(subject).to_not be_valid
      subject.username = 'e@xample'
      expect(subject).to_not be_valid
    end

    it 'Accepts valid username formats' do
      subject.username = 'e'
      expect(subject).to be_valid
      subject.username = 'exa mple'
      expect(subject).to be_valid
      subject.username = 'exa-mple example'
      expect(subject).to be_valid
    end

    it 'Username must be unique' do
      user2 = build(:user2, username: subject.username)
      expect(user2).to_not be_valid
    end

    it 'Requires confirmation for change' do
      subject.username = 'new-username'
      subject.username_confirmation = ''
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:username_confirmation]).to eq ['Usernames do not match']
      subject.username_confirmation = 'new-username'
      expect(subject).to be_valid
    end
  end

  describe 'Email validations' do
    it 'Accepts valid emails' do
      subject.email = 'new@example.com'
      expect(subject).to be_valid
      subject.email = 'ad_m.in@exam-ple.co.uk'
      expect(subject).to be_valid
    end

    it 'Rejects emails with incorrect format' do
      subject.email = '@example.com'
      expect(subject).to_not be_valid
      subject.email = 'example.com'
      expect(subject).to_not be_valid
      subject.email = 'admin@'
      expect(subject).to_not be_valid
      subject.email = 'admin'
      expect(subject).to_not be_valid
    end

    it 'Rejects emails with invalid charaters' do
      subject.email = '\#@example.com'
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:email]).to eq ['Email must be valid format']
    end

    it 'Email must be unique' do
      user2 = build(:user2, email: subject.email)
      expect(user2).to_not be_valid
    end

    it 'Requires confirmation for change' do
      subject.email = 'new@example.com'
      subject.email_confirmation = ''
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:email_confirmation]).to eq ['Emails do not match']
      subject.email_confirmation = 'new@example.com'
      expect(subject).to be_valid
    end
  end

  describe 'Mobile number validations' do
    it 'Rejects non-unique mobile numbers' do
      user2 = build(:user2, mobile_number: subject.mobile_number)
      expect(user2).to_not be_valid
    end

    it 'Rejects invalid UK mobile numbers with message' do
      subject.mobile_number = '01234567'
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:mobile_number]).to eq ['Please enter valid UK mobile phone number']
    end

    it 'Requires confirmation for change' do
      subject.mobile_number = '+447345678901'
      subject.mobile_number_confirmation = ''
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:mobile_number_confirmation]).to eq ['Mobile phone numbers do not match']
      subject.mobile_number_confirmation = '+447345678901'
      expect(subject).to be_valid
    end
  end

  describe 'Before_validation: mobile_number' do
    it 'Adds area code to standard UK mobile number' do
      subject.mobile_number = '07345678902'
      subject.mobile_number_confirmation = '07345678902'
      subject.save
      expect(subject.mobile_number).to eq('+447345678902')
    end
  end

  describe 'after_save: #remove_password_reset' do
    it 'password updated after reset' do
      subject.send_password_reset_email!
      subject.update(password: 'new-password', password_confirmation: 'new-password')
      subject.reload
      expect(subject.password_reset_token).to eq(nil)
      expect(subject.password_reset_expiry).to eq(nil)
    end
  end

  describe '#send_password_reset_email!' do
    it 'Adds a password reset token to user' do
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('testtoken')
      subject.send_password_reset_email!
      expect(subject.password_reset_token).to eq('testtoken')
    end

    it 'Password reset token is unique' do
      create(:user2, password_reset_token: 'not_unique_token')
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('not_unique_token', 'unique_token')
      subject.send_password_reset_email!
      expect(subject.password_reset_token).to eq('unique_token')
    end

    it 'Adds a password reset expiry to user' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      subject.send_password_reset_email!
      expect(subject.password_reset_expiry).to eq(Time.zone.now + 1.hour)
    end

    it 'Password reset email requested to be sent' do
      expect(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
      subject.send_password_reset_email!
    end
  end

  describe '.user_from_password_reset_token' do
    it 'Returns user if reset token matches and in date' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      subject.update_attribute(:password_reset_token, 'test-token')
      subject.update_attribute(:password_reset_expiry, Time.zone.now + 1.hour)
      travel_to Time.zone.local(2020, 04, 19, 00, 59, 00)
      expect(User.user_from_password_reset_token('test-token')).to eq(subject)
    end

    it 'Returns nil if reset token matches and but not in date' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      subject.update_attribute(:password_reset_token, 'test-token')
      subject.update_attribute(:password_reset_expiry, Time.zone.now + 1.hour)
      travel_to Time.zone.local(2020, 04, 19, 01, 01, 00)
      expect(User.user_from_password_reset_token('test-token')).to eq(nil)
    end

    it 'Returns nil if reset token invalid' do
      subject.update_attribute(:password_reset_token, 'test-token')
      expect(User.user_from_password_reset_token('not_valid')).to eq(nil)
    end

    it 'Returns nil if reset token no present' do
      expect(User.user_from_password_reset_token(nil)).to eq(nil)
    end
  end

  describe '#send_password_updated_email!' do
    it 'Password updated email sent to user' do
      expect(PasswordMailer).to receive_message_chain(:with, :password_updated_email, :deliver_now)
      subject.send_password_updated_email!
    end
  end
end

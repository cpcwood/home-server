require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#send_password_reset_email!' do
    it 'adds a password reset token to user' do
      allow(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('testtoken')
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_token == 'testtoken').to eq(true)
    end

    it 'adds a password reset expiry to user' do
      allow(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_expiry).to eq(Time.zone.now + 1.hour)
    end

    it 'password reset email requested to be sent' do
      expect(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
      @test_user.send_password_reset_email!
    end
  end
end





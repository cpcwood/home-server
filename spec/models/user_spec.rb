require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    allow(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
    # @test_user.update(password_reset_token: nil)
    # @test_user.update(password_reset_expiry: nil)
  end

  describe '#send_password_reset_email!' do
    it 'adds a password reset token to user' do
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('testtoken')
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_token == 'testtoken').to eq(true)
    end

    it 'adds a password reset expiry to user' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_expiry).to eq(Time.zone.now + 1.hour)
    end

    it 'password reset email requested to be sent' do
      expect(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
      @test_user.send_password_reset_email!
    end
  end

  describe '#user_from_password_reset_token' do
    it 'returns user if reset token matches and in date' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      @test_user.update(password_reset_token: 'test-token')
      @test_user.update(password_reset_expiry: Time.zone.now + 1.hour)
      travel_to Time.zone.local(2020, 04, 19, 00, 59, 00)
      expect(User.user_from_password_reset_token('test-token')).to eq(@test_user)
    end

    it 'returns nil if reset token matches and but not in date' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      @test_user.update(password_reset_token: 'test-token')
      @test_user.update(password_reset_expiry: Time.zone.now + 1.hour)
      travel_to Time.zone.local(2020, 04, 19, 01, 01, 00)
      expect(User.user_from_password_reset_token('test-token')).to eq(nil)
    end

    it 'returns nil if reset token invalid' do
      @test_user.update(password_reset_token: 'test-token')
      expect(User.user_from_password_reset_token('not_valid')).to eq(nil)
    end
  end
end

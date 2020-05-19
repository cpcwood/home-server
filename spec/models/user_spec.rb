require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    allow(PasswordMailer).to receive_message_chain(:with, :password_reset_email, :deliver_now)
  end

  describe '#send_password_reset_email!' do
    it 'Adds a password reset token to user' do
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('testtoken')
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_token).to eq('testtoken')
    end

    it 'Password reset token is unique user' do
      User.create!(username: 'another_user', password: 'password', email: 'email', password_reset_token: 'not_unique_token')
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
      @test_user.update(password_reset_token: 'test-token')
      @test_user.update(password_reset_expiry: Time.zone.now + 1.hour)
      travel_to Time.zone.local(2020, 04, 19, 00, 59, 00)
      expect(User.user_from_password_reset_token('test-token')).to eq(@test_user)
    end

    it 'Returns nil if reset token matches and but not in date' do
      travel_to Time.zone.local(2020, 04, 19, 00, 00, 00)
      @test_user.update(password_reset_token: 'test-token')
      @test_user.update(password_reset_expiry: Time.zone.now + 1.hour)
      travel_to Time.zone.local(2020, 04, 19, 01, 01, 00)
      expect(User.user_from_password_reset_token('test-token')).to eq(nil)
    end

    it 'Returns nil if reset token invalid' do
      @test_user.update(password_reset_token: 'test-token')
      expect(User.user_from_password_reset_token('not_valid')).to eq(nil)
    end

    it 'Returns nil if reset token no present' do
      expect(User.user_from_password_reset_token(nil)).to eq(nil)
    end
  end

  describe '#update_password!' do
    it 'Updates password' do
      @test_user.update_password!('new_password')
      expect(@test_user.password).to eq('new_password')
    end

    it 'Removes password reset token' do
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_token).not_to eq(nil)
      @test_user.update_password!('new_password')
      expect(@test_user.password_reset_token).to eq(nil)
    end

    it 'Removes password reset expiry' do
      @test_user.send_password_reset_email!
      expect(@test_user.password_reset_expiry).not_to eq(nil)
      @test_user.update_password!('new_password')
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

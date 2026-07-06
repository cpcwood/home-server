require 'rails_helper'

RSpec.describe TwoFactorAuthService do
  subject(:service) { described_class }

  let(:user) { create(:user, :with_totp) }
  let(:session) { {} }

  describe '.start / .started? / .get_user' do
    it 'stores and retrieves the pending user' do
      service.start(session, user)
      expect(service.started?(session)).to eq(true)
      expect(service.get_user(session)).to eq(user)
    end

    it 'is not started for an empty session' do
      expect(service.started?(session)).to eq(false)
    end
  end

  describe '.auth_code_format_valid?' do
    it 'accepts six digits' do
      expect(service.auth_code_format_valid?('123456')).to eq(true)
    end

    it 'rejects other formats' do
      expect(service.auth_code_format_valid?('12345a')).to eq(false)
    end
  end

  describe '.auth_code_valid?' do
    before { service.start(session, user) }

    it 'is true for the current totp code' do
      code = ROTP::TOTP.new(user.otp_secret).now
      expect(service.auth_code_valid?(session: session, auth_code: code)).to eq(true)
    end

    it 'is false for a wrong code' do
      expect(service.auth_code_valid?(session: session, auth_code: '000000')).to eq(false)
    end
  end
end

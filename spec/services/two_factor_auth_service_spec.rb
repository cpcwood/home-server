require 'spec_helper'

describe TwoFactorAuthService do
  describe '.start' do
    it 'user start two factor auth flow' do
      mock_session = {}
      subject.start(mock_session, @test_user)
      expect(mock_session[:two_factor_auth_id]).to eq(@test_user.id)
    end
  end
end
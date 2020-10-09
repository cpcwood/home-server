require 'spec_helper'

describe TwoFactorAuthService do
  before(:each) do
    @session = {}
  end
  
  describe '.start' do
    it 'user start two factor auth flow' do
      subject.start(@session, @test_user)
      expect(@session[:two_factor_auth_id]).to eq(@test_user.id)
    end
  end

  describe '.started?' do
    it 'two factor not started' do
      expect(subject.started?(@session)).to eq(false)
    end

    it 'two factor started' do
      subject.start(@session, @test_user)
      expect(subject.started?(@session)).to eq(true)
    end
  end
end
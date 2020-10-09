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

  describe '.send_auth_code' do
    before(:each) do
      subject.start(@session, @test_user)
    end

    it 'user does not exist' do
      @test_user.destroy
      expect(subject.send_auth_code(@session)).to eq(false)
    end

    it 'user has no mobile number' do
      @test_user.mobile_number = nil
      @test_user.save
      expect(subject.send_auth_code(@session)).to eq(false)
    end

    it 'twilio error' do
      allow(Twilio::REST::Client).to receive(:new).and_raise('error')
      expect(subject.send_auth_code(@session)).to eq(false)
    end
  end
end
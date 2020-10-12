require 'spec_helper'

describe TwoFactorAuthService do
  let(:session) { {} }

  describe '.start' do
    it 'user start two factor auth flow' do
      subject.start(session, @test_user)
      expect(session[:two_factor_auth_id]).to eq(@test_user.id)
    end
  end

  describe '.started?' do
    it 'two factor not started' do
      expect(subject.started?(session)).to eq(false)
    end

    it 'two factor started' do
      subject.start(session, @test_user)
      expect(subject.started?(session)).to eq(true)
    end
  end

  describe '.send_auth_code' do
    before(:each) do
      subject.start(session, @test_user)
    end

    it 'user does not exist' do
      @test_user.destroy
      expect(subject.send_auth_code(session)).to eq(false)
    end

    it 'user has no mobile number' do
      @test_user.mobile_number = nil
      @test_user.save
      expect(subject.send_auth_code(session)).to eq(false)
    end

    it 'twilio error' do
      allow(Twilio::REST::Client).to receive(:new).and_raise('error')
      expect(subject.send_auth_code(session)).to eq(false)
    end

    it 'successful send request' do
      expect_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationList).to receive(:create).with(to: @test_user.mobile_number, channel: 'sms')
      expect(subject.send_auth_code(session)).to eq(true)
      expect(session[:two_factor_auth_code_sent]).to eq(true)
    end

    it 'send request already made' do
      allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationList).to receive(:create)
      subject.send_auth_code(session)
      expect_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationList).not_to receive(:create)
      expect(subject.send_auth_code(session)).to eq(true)
    end
  end

  describe '.verify_auth_code' do
    let(:auth_code) { '123456' }

    before(:each) do
      subject.start(session, @test_user)
      allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationList).to receive(:create)
      subject.send_auth_code(session)
    end

    it 'auth code not yet sent' do
      new_session = {}
      subject.start(new_session, @test_user)
      expect(subject.verify_auth_code(session: new_session, auth_code: auth_code)).to eq(false)
    end

    it 'user does not exist' do
      @test_user.destroy
      expect(subject.verify_auth_code(session: session, auth_code: auth_code)).to eq(false)
    end

    it 'invalid auth code' do
      verification_double = double('verification', status: 'failed')
      allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).and_return(verification_double)
      expect(subject.verify_auth_code(session: session, auth_code: auth_code)).to eq(false)
    end

    it 'valid auth code' do
      verification_double = double('verification', status: 'approved')
      allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).and_return(verification_double)
      expect(subject.verify_auth_code(session: session, auth_code: auth_code)).to eq(true)
    end
  end
end
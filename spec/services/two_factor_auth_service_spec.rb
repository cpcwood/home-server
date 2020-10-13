describe TwoFactorAuthService do
  let(:user) { create(:user) }
  let(:session) { {} }

  describe '.start' do
    it 'user start two factor auth flow' do
      subject.start(session, user)
      expect(session[:two_factor_auth_id]).to eq(user.id)
    end
  end

  describe '.started?' do
    it 'two factor not started' do
      expect(subject.started?(session)).to eq(false)
    end

    it 'two factor started' do
      subject.start(session, user)
      expect(subject.started?(session)).to eq(true)
    end
  end

  describe '.send_auth_code' do
    before(:each) do
      subject.start(session, user)
    end

    it 'user does not exist' do
      user.destroy
      expect(subject.send_auth_code(session)).to eq(false)
    end

    it 'user has no mobile number' do
      user.mobile_number = nil
      user.save
      expect(subject.send_auth_code(session)).to eq(false)
    end

    it 'twilio error' do
      allow(subject).to receive(:twilio_client).and_raise('error')
      expect(subject.send_auth_code(session)).to eq(false)
    end

    it 'successful send request' do
      expect_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationList).to receive(:create).with(to: user.mobile_number, channel: 'sms')
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

  describe '.auth_code_format_valid?' do
    it 'format valid' do
      auth_code = '1' * 6
      expect(subject.auth_code_format_valid?(auth_code)).to eq(true)
    end

    it 'format invalid' do
      auth_code = '1' * 5
      expect(subject.auth_code_format_valid?(auth_code)).to eq(false)
      auth_code = '1' * 7
      expect(subject.auth_code_format_valid?(auth_code)).to eq(false)
      auth_code = 'a' * 6
      expect(subject.auth_code_format_valid?(auth_code)).to eq(false)
    end
  end

  describe '.auth_code_valid?' do
    let(:auth_code) { '123456' }

    before(:each) do
      subject.start(session, user)
      allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationList).to receive(:create)
      subject.send_auth_code(session)
    end

    it 'auth code not yet sent' do
      new_session = {}
      subject.start(new_session, user)
      expect(subject.auth_code_valid?(session: new_session, auth_code: auth_code)).to eq(false)
    end

    it 'user does not exist' do
      user.destroy
      expect(subject.auth_code_valid?(session: session, auth_code: auth_code)).to eq(false)
    end

    it 'twilio error' do
      allow(subject).to receive(:twilio_client).and_raise('error')
      expect(subject.auth_code_valid?(session: session, auth_code: auth_code)).to eq(false)
    end

    it 'invalid auth code' do
      verification_double = double('verification', status: 'failed')
      allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).and_return(verification_double)
      expect(subject.auth_code_valid?(session: session, auth_code: auth_code)).to eq(false)
    end

    it 'valid auth code' do
      verification_double = double('verification', status: 'approved')
      expect_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).with(to: user.mobile_number, code: auth_code).and_return(verification_double)
      expect(subject.auth_code_valid?(session: session, auth_code: auth_code)).to eq(true)
    end
  end

  describe '.get_user' do
    before(:each) do
      subject.start(session, user)
    end

    it 'user does not exist' do
      user.destroy
      expect(subject.get_user(session)).to eq(nil)
    end

    it 'user exists' do
      expect(subject.get_user(session)).to eq(user)
    end
  end
end
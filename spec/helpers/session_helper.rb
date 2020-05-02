def password_athenticate_admin(user:, password:, captcha_success:)
  stub_request(:post, "https://www.google.com/recaptcha/api/siteverify?response=#{captcha_success}&secret=test")
    .to_return(status: 200, body: "{\"success\": #{captcha_success}}", headers: {})
  post '/login', params: { user: user, password: password, 'g-recaptcha-response' => captcha_success }
end

def block_twilio_verification_requests
  stub_request(:post, 'https://verify.twilio.com/v2/Services/VAbe124f2ff38bc35c1de5c4f5f3fb14c8/Verifications')
    .to_return(status: 200, body: '', headers: {})
end

def block_twilio_verification_checks
  stub_request(:post, 'https://verify.twilio.com/v2/Services/VAbe124f2ff38bc35c1de5c4f5f3fb14c8/VerificationCheck')
    .to_return(status: 200, body: '', headers: {})
end

def login_admin
  block_twilio_verification_checks
  password_athenticate_admin(user: 'admin', password: 'Securepass1', captcha_success: true)
  auth_code = '1234'
  verification_double = double('verification', status: 'approved')
  allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).and_return(verification_double)
  post '/2fa', params: { auth_code: auth_code }
  follow_redirect!
end
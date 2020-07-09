require 'spec_helpers/session_helper'
require 'twilio-ruby'

def login_feature
  stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify?response&secret=test')
    .to_return(status: 200, body: '{"success": true}', headers: {})
  block_twilio_verification_checks
  verification_double = double('verification', status: 'approved')
  allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).and_return(verification_double)
  visit('/')
  page.find(:css, '#login-button').click
  fill_in('user', with: @test_user.username)
  fill_in('password', with: @test_user_password)
  click_button('Login')
  fill_in('auth_code', with: '123456')
  click_button('Login')
end
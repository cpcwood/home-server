require 'spec_helpers/session_helper'

def login_feature
  stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify?response&secret=test')
    .to_return(status: 200, body: '{"success": true}', headers: {})
  stub_two_factor_auth
  visit('/')
  page.find(:css, '#login-button').click
  fill_in('user', with: @test_user.username)
  fill_in('password', with: @test_user_password)
  click_button('Login')
  fill_in('auth_code', with: '123456')
  click_button('Login')
end

def stub_two_factor_auth
  allow(TwoFactorAuthService).to receive(:send_auth_code).and_return(true)
  allow(TwoFactorAuthService).to receive(:auth_code_valid?).and_return(true)
  # allow(TwoFactorAuthService).to receive(:get_user).and_return(@test_user)
end
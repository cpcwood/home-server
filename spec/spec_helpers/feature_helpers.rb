require 'spec_helpers/session_helper'
require 'spec_helpers/models_helper'

def login_feature
  stub_recaptcha_service
  stub_two_factor_auth_service
  visit('/')
  page.find(:css, '#login-button').click
  fill_in('user', with: @test_user.username)
  fill_in('password', with: @test_user_password)
  click_button('Login')
  fill_in('auth_code', with: '123456')
  click_button('Login')
end
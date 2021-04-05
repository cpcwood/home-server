require 'spec_helpers/session_helper'
require 'spec_helpers/db_helper'

def login_feature
  stub_recaptcha_service
  stub_two_factor_auth_service
  visit('/')
  page.find(:css, '.hamburger-container').click
  page.find(:css, '#login-button').click
  fill_in('user', with: @user.username)
  fill_in('password', with: @user_password)
  js_click_input
  fill_in('auth_code', with: '123456')
  sleep(0.1)
  js_click_input
  sleep(0.1)
end

def js_true?
  RSpec.current_example.metadata[:js]
end

def js_click_input
  if js_true?
    find('.input-submit').click
  else
    find('.input-submit-tag', visible: false).click
  end
end
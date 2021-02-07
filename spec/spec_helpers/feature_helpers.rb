require 'spec_helpers/session_helper'
require 'spec_helpers/db_helper'

def login_feature
  stub_recaptcha_service
  stub_two_factor_auth_service
  visit('/')
  page.find(:css, '#login-button').click
  fill_in('user', with: @user.username)
  fill_in('password', with: @user_password)
  find('label', :text => 'Login').click
  save_page
  fill_in('auth_code', with: '123456')
  find('label', :text => 'Login').click
end
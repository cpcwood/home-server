require 'helpers/session_helper'
require 'twilio-ruby'

feature 'Password Reset' do
  scenario 'Filling in password reset form' do
    stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify?response&secret=test')
      .to_return(status: 200, body: '{"success": true}', headers: {})
    visit('/login')
    click_on('Forgotten Password')
    fill_in('email', with: 'admin@example.com')
    click_button('Reset Password')
    expect(page).to have_content('If the submitted email is associated with an account, a password reset link will be sent')
    expect(current_path).to eq('/login')
    expect(PasswordResetJob).to have_been_enqueued.exactly(:once)
  end

  scenario 'Submitting new password' do
    # Reset password
    @test_user.send_password_reset_email!
    reset_token = @test_user.password_reset_token
    visit("/reset-password?reset_token=#{reset_token}")
    fill_in('password', with: 'new_password')
    fill_in('password_confirmation', with: 'new_password')
    click_button('Reset Password')
    expect(current_path).to eq('/login')
    expect(page).to have_content('Password updated')

    # Attempt to reset password again with same token
    visit("/reset-password?reset_token=#{reset_token}")
    expect(current_path).to eq('/login')
    expect(page).to have_content('Password reset token expired')

    # Login with new password
    stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify?response&secret=test')
      .to_return(status: 200, body: '{"success": true}', headers: {})
    block_twilio_verification_checks
    verification_double = double('verification', status: 'approved')
    allow_any_instance_of(Twilio::REST::Verify::V2::ServiceContext::VerificationCheckList).to receive(:create).and_return(verification_double)
    fill_in('user', with: 'admin')
    fill_in('password', with: 'new_password')
    click_button('Login')
    fill_in('auth_code', with: '123456')
    click_button('Login')
    expect(page).to have_content('admin welcome back to your home-server!')
  end
end
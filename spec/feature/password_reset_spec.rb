feature 'Password reset', feature: true do
  before(:each) do
    seed_db
    stub_recaptcha_service
  end

  scenario 'Filling in password reset form' do
    visit('/login')
    click_on('Forgotten Password')
    fill_in('email', with: @user.email)
    click_button('Reset Password')
    expect(page).to have_content('If the submitted email is associated with an account, a password reset link will be sent')
    expect(current_path).to eq('/login')
    expect(PasswordResetJob).to have_been_enqueued.exactly(:once)
  end

  scenario 'Submitting new password' do
    # Reset password
    @user.send_password_reset_email!
    reset_token = @user.password_reset_token
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
    stub_two_factor_auth_service
    fill_in('user', with: @user.username)
    fill_in('password', with: 'new_password')
    click_button('Login')
    fill_in('auth_code', with: '123456')
    click_button('Login')
    expect(page).to have_content("#{@user.username} welcome back to your home-server!")
  end
end
feature 'Admin update details', feature: true do
  before(:each) do
    seed_user_and_settings
    login_feature
    visit('admin/user_settings')
  end

  scenario 'Update username' do
    new_username = 'new username'
    fill_in('username[username]', with: new_username)
    fill_in('username[username_confirmation]', with: new_username)
    fill_in('current_password[password]', with: @user_password)
    click_button('Update details')
    expect(page).to have_content('Username updated!')
    @user.reload
    expect(@user.username).to eq(new_username)
  end

  scenario 'Update email' do
    new_email = 'new@example.com'
    fill_in('email[email]', with: new_email)
    fill_in('email[email_confirmation]', with: new_email)
    fill_in('current_password[password]', with: @user_password)
    click_button('Update details')
    expect(page).to have_content('Email address updated!')
    @user.reload
    expect(@user.email).to eq(new_email)
  end

  scenario 'Update password' do
    new_password = 'newpassword'
    fill_in('password[password]', with: new_password)
    fill_in('password[password_confirmation]', with: new_password)
    fill_in('current_password[password]', with: @user_password)
    click_button('Update details')
    expect(page).to have_content('Password updated!')
    @user.reload
    expect(@user.authenticate(new_password)).to eq(@user)
  end

  scenario 'Update mobile number' do
    fill_in('mobile_number[mobile_number]', with: '07123456789')
    fill_in('mobile_number[mobile_number_confirmation]', with: '07123456789')
    fill_in('current_password[password]', with: @user_password)
    click_button('Update details')
    expect(page).to have_content('Mobile number updated!')
    @user.reload
    expect(@user.mobile_number).to eq('+447123456789')
  end
end
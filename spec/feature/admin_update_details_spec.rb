require 'spec_helpers/feature_helpers'

feature 'Admin update details', feature: true do
  before(:each) do
    seed_db
  end

  scenario 'Update username' do
    login_feature
    visit('admin/user_settings')
    fill_in('username[username]', with: 'new_username')
    fill_in('username[username_confirmation]', with: 'new_username')
    fill_in('current_password[password]', with: @test_user_password)
    click_button('Update details')
    expect(page).to have_content('Username updated!')
    @test_user.reload
    expect(@test_user.username).to eq('new_username')
  end

  scenario 'Update email' do
    login_feature
    visit('admin/user_settings')
    fill_in('email[email]', with: 'new@example.com')
    fill_in('email[email_confirmation]', with: 'new@example.com')
    fill_in('current_password[password]', with: @test_user_password)
    click_button('Update details')
    expect(page).to have_content('Email address updated!')
    @test_user.reload
    expect(@test_user.email).to eq('new@example.com')
  end

  scenario 'Update password' do
    login_feature
    visit('admin/user_settings')
    fill_in('password[password]', with: 'newpassword')
    fill_in('password[password_confirmation]', with: 'newpassword')
    fill_in('current_password[password]', with: @test_user_password)
    click_button('Update details')
    expect(page).to have_content('Password updated!')
    @test_user.reload
    expect(@test_user.authenticate('newpassword')).to eq(@test_user)
  end

  scenario 'Update mobile number' do
    login_feature
    visit('admin/user_settings')
    fill_in('mobile_number[mobile_number]', with: '07123456789')
    fill_in('mobile_number[mobile_number_confirmation]', with: '07123456789')
    fill_in('current_password[password]', with: @test_user_password)
    click_button('Update details')
    expect(page).to have_content('Mobile number updated!')
    @test_user.reload
    expect(@test_user.mobile_number).to eq('+447123456789')
  end
end
require 'helpers/feature_helpers'

feature 'Admin update details' do
  scenario 'Admin can change username' do
    login_feature
    visit('admin/user-settings')
    fill_in('username[username]', with: 'new_username')
    fill_in('username[username_confirmation]', with: 'new_username')
    fill_in('current_password[password]', with: @test_user_password)
    click_button('Update details')
    expect(page).to have_content('User updated!')
    @test_user.reload
    expect(@test_user.username).to eq('new_username')
  end
end
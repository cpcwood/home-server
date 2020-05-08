feature 'Password Reset' do
  scenario 'Filling in password reset form' do
    visit('/login')
    click_on('Forgotten Password')
    fill_in('user', with: 'admin')
    click_button('Request Password Reset')
    expect(page).to have_content('If the submitted email is associated with an account, a password reset link will be sent')
    have_current_path('/login')
  end
end
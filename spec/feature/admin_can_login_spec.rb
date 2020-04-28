feature 'Admin login' do
  scenario 'admin can login' do
    visit('/login')
    fill_in('user', with: 'admin@example.com')
    fill_in('password', with: 'Securepass1')
    click_button('Login')
    expect(page).to have_content 'admin welcome back to your home-server!'
  end

  scenario 'incorrect logins display alert' do
    visit('/login')
    fill_in('user', with: 'incorrect_email')
    fill_in('password', with: 'Securepass1')
    click_button('Login')
    expect(page).to have_content 'User not found'
  end
end
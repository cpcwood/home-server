feature 'Unauthorised user redirect' do
  scenario 'only logged in user can access admin page' do
    visit('/admin')
    expect(page).to have_current_path('/')
  end

  scenario 'old user sessions for deleted users are reset' do
    user = User.create(username: 'olduser', email: 'oldusers@example.com', password: 'Securepass1')
    visit('/login')
    fill_in('user', with: 'olduser')
    fill_in('password', with: 'Securepass1')
    click_button('Login')
    user.destroy
    visit('/admin')
    expect(page).to have_current_path('/')
  end
end
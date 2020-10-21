feature 'Admin login logout', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  scenario 'Admin can login and logout' do
    login_feature
    expect(page).to have_content("#{@user.username} welcome back to your home-server!")
    page.find(:css, '#logout-button').click
    expect(current_path).to eq '/'
  end
end
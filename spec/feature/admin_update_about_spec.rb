feature 'Admin update site settings', feature: true, slow: true do
  before(:each) do
    seed_db
    login_feature
  end

  scenario 'Update site settings' do
    visit('/about')
    click_on('Admin Edit')
    fill_in('about[name]', with: 'new section name')
    fill_in('about[about_me]', with: '#new about me text in markdown')
    click_button('Update About')
    expect(page).to have_content('Name updated!')
    expect(page).to have_content('About me updated!')
    click_on('Return to Section')
    expect(page).to have_content('new section name')
    expect(page).to have_content('<h1>new about me text in markdown</h1>')
  end
end
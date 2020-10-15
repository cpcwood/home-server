feature 'Admin update about section', feature: true, slow: true do
  scenario 'Update about settings' do
    seed_db
    visit('/about')
    expect(page).not_to have_button('Admin Edit')
    login_feature
    visit('/about')
    click_on('Admin Edit')
    fill_in('about[name]', with: 'new section name')
    fill_in('about[about_me]', with: "#new about me text in markdown\n
      ```ruby
        def some(code)
      ```")
    click_button('Update About')
    expect(page).to have_content('Name updated!')
    expect(page).to have_content('About me updated!')
    click_on('View Section')
    expect(page).to have_content('new section name')
    expect(page.html).to match('<h1>new about me text in markdown</h1>')
    expect(page).to have_selector('code')
  end
end
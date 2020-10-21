feature 'Admin update site settings', feature: true, slow: true do
  before(:each) do
    seed_test_user
    login_feature
  end

  scenario 'Update site settings' do
    visit('admin/site_settings')
    fill_in('site_setting[name]', with: 'new_site_name')
    fill_in('site_setting[header_text]', with: 'new_header')
    fill_in('site_setting[subtitle_text]', with: 'new_subtitle')
    click_button('Update site settings')
    expect(page).to have_content('Name updated!')
    expect(page).to have_content('Header text updated!')
    expect(page).to have_content('Subtitle text updated!')
    visit('/')
    expect(page).to have_content('new_site_name')
    expect(page).to have_content('new_header')
    expect(page).to have_content('new_subtitle')
  end
end
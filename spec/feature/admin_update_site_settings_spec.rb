require 'spec_helpers/feature_helpers'

feature 'Admin update site settings' do
  scenario 'Update site name' do
    login_feature
    visit('admin/site_settings')
    fill_in('site_setting[name]', with: 'new_site_name')
    click_button('Update site settings')
    expect(page).to have_content('Site name updated!')
    visit('/')
    expect(page).to have_content('new_site_name')
  end
end
require 'helpers/feature_helpers'

feature 'Admin login logout' do
  scenario 'Admin can login and logout' do
    login_feature
    expect(page).to have_content('admin welcome back to your home-server!')
    page.find(:css, '#logout-button').click
    expect(current_path).to eq '/'
  end
end
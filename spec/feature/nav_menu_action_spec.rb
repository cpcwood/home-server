feature 'Nav menu action', feature: true, js: true do
  before(:each) do
    seed_test_user
  end

  scenario 'Clicking hamburger opens and closes navbar menu' do
    visit('/')
    page.find(:css, '.hamburger-container').click
    expect(page).to have_css('.sidebar-open')
    page.find(:css, '.hamburger-container').click
    expect(page).not_to have_css('.sidebar-open')
  end
end
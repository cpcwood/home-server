feature 'Nav menu action', feature: true, js: true do
  scenario 'Clicking hamburger opens and closes navbar menu' do
    visit('/')
    page.find(:css, '.hamburger_container').click
    expect(page).to have_css('.sidebar_open')
    page.find(:css, '.hamburger_container').click
    expect(page).not_to have_css('.sidebar_open')
  end
end
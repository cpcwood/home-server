feature 'Footer', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  scenario 'links are rendered' do
    visit('/')
    expect(page).to have_css('footer .footer-links')
    expect(page).to have_selector(:css, "a.github-link[href='#{@about.github_link}']")
    expect(page).to have_selector(:css, "a.linkedin-link[href='#{@about.linkedin_link}']")
    expect(page).to have_selector(:css, "a.homepage-link[href='#{root_path}']")
  end
end
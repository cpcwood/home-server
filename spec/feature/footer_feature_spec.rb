feature 'Footer', feature: true, js: true do
  before(:each) do
    seed_user_and_settings
    seed_about
  end

  scenario 'links are rendered' do
    visit('/')
    expect(page).to have_css('footer .footer-links')
    github_link = page.find(:css, '.footer-links a.github-link')
    expect(github_link).to have_link(nil, href: @about.github_link)

    linkedin_link = page.find(:css, '.footer-links a.linkedin-link')
    expect(linkedin_link).to have_link(nil, href: @about.linkedin_link)

    homepage_link = page.find(:css, '.footer-links a.homepage-link')
    expect(homepage_link).to have_link(nil, href: root_path)
  end
end
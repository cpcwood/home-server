feature 'projects feature', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  context 'public user' do
    scenario 'no projects' do
      visit('/')
      click_on('PROJECTS')
      expect(page).to have_current_path('/code-snippets')
      expect(page).to have_content('There are projects here...')
    end
  end
end
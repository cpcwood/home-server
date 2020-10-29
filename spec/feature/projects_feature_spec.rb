feature 'projects feature', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  context 'public user' do
    scenario 'no projects' do
      visit('/')
      click_on('PROJECTS')
      expect(page).to have_current_path('/projects')
      expect(page).to have_content('There are no projects here...')
    end

    scenario 'projects present' do
      seed_project
      visit('/projects')
      expect(page).not_to have_button('Admin Edit')
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.overview)
    end
  end

  context 'admin user' do
    before(:each) do
      login_feature
      seed_project
    end

    scenario 'create code snippet' do
      visit('/projects')
      click_on('Admin Edit')
      expect(page).to have_current_path('/admin/projects')
      click_on('Create New')
      fill_in('project[title]', with: 'project title')
      fill_in('project[overview]', with: 'project overview')
      fill_in('project[github_link]', with: 'https://example.com/github')
      fill_in('project[site_link]', with: 'https://example.com/site')
      fill_in('project[date]', with: DateTime.new(2020, 04, 19, 0, 0, 0))
      click_on('Submit')
    end
  end
end
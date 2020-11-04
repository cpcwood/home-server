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
      find_field('new_project_images[image_files][]').set(Rails.root.join('spec/files/sample_image.jpg'))
      click_on('Submit')
      expect(page).to have_content('Project created')
      expect(page).to have_content('project title')
      expect(page).to have_content('project overview')
      expect(Project.first.project_images.length).to be(1)
      click_on('View Section')
      expect(page).to have_content('project title')
      expect(page).to have_content('project overview')
      expect(page.html).to include('https://example.com/github')
      expect(page.html).to include('https://example.com/site')
    end

    scenario 'update project' do
      seed_project
      visit('/admin/projects')
      first('.show-button').click
      expect(page).to have_content(@project.overview)
      fill_in('project[title]', with: 'new title')
      fill_in('snippet[text]', with: 'new code snippet')
      fill_in('snippet[extension]', with: 'rb')
      click_button('Submit')
      expect(page).to have_content('Project updated')
      expect(page).to have_content('new title')
    end

    scenario 'delete project' do
      seed_project
      visit('/admin/projects')
      first('.show-button').click
      first('.destroy-button').click
      expect(page).to have_content('Project removed')
      expect(page).to have_content('There are no projects here...')
    end
  end
end
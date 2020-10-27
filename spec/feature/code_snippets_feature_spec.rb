feature 'code snippets feature', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  context 'public user' do
    scenario 'no code snippets' do
      visit('/')
      click_on('CODE SNIPPETS')
      expect(page).to have_current_path('/code-snippets')
      expect(page).to have_content('There are no code snippets here...')
    end

    scenario 'view code snippet' do
      seed_code_snippet
      visit('/code-snippets')
      expect(page).not_to have_button('Admin Edit')
      expect(page).to have_content(@code_snippet.title)
      expect(page).to have_content(@code_snippet.overview)
      first('.show-button').click
      expect(page).to have_content(@code_snippet.text)
    end
  end

  context 'admin user' do
    before(:each) do
      login_feature
    end

    scenario 'create code snippit' do
      visit('/code-snippets')
      click_on('Admin Edit')
      click_on('Create New')
      fill_in('code_snippet[title]', with: 'code snippet title')
      fill_in('code_snippet[overview]', with: 'code snippet overview')
      fill_in('code_snippet[snippet]', with: 'def code_snippet; end')
      fill_in('code_snippet[text]', with: 'code snippet text content')
      click_button('Submit')
      expect(page).to have_content('Code snippet created')
      expect(page).to have_content('code snippet title')
      expect(page).to have_content('code snippet overview')
      click_on('View Section')
      expect(page).to have_content('Code snippet created')
      expect(page).to have_content('code snippet title')
      expect(page).to have_content('code snippet overview')
      first('.show-button').click
      expect(page).to have_content('code snippet text content')
      expect(page).to have_content('def code_snippet; end')
    end
  end
end
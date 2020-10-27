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

    scenario 'view blog post' do
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
    end
  end
end
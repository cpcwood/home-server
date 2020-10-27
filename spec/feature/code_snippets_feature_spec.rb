feature 'code snippets feature', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  context 'public user' do
    
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
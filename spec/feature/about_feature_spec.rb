feature 'Admin update about section', feature: true do
  before(:each) do
    seed_user_and_settings
    seed_about
  end

  context 'public user' do
    scenario 'view about' do
      visit('/')
      click_on('ABOUT')
      expect(page).to have_current_path('/about')
      expect(page).not_to have_button('Admin Edit')
      expect(page).to have_content(@about.section_title)
      expect(page).to have_content(@about.about_me)
    end
  end

  context 'admin user' do
    scenario 'Update about settings' do
      login_feature
      visit('/about')
      click_on('Edit')
      fill_in('about[section_title]', with: 'new section name')
      fill_in('about[name]', with: 'new about name')
      fill_in('about[location]', with: 'new about location')
      fill_in('about[contact_email]', with: 'new@example.com')
      fill_in('about[about_me]', with: "#new about me text in markdown\n
        ```ruby
          def some(code)
        ```")
      find_field('about[profile_image_attributes][image_file]').set(Rails.root.join('spec/files/sample_image.jpg'))
      click_button('Update About')
      expect(page).to have_content('Section title updated!')
      expect(page).to have_content('About me updated!')
      expect(page).to have_content('Name updated!')
      expect(page).to have_content('Location updated!')
      expect(page).to have_content('Contact email updated!')
      click_on('Return')
      expect(page).to have_content('new section name')
      expect(page.html).to match('<h1>new about me text in markdown</h1>')
      expect(page).to have_selector('code')
      expect(page).to have_selector('img.profile-image')
    end
  end
end

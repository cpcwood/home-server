feature 'admin update gallery', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  context 'public user' do
    scenario 'no gallery images' do
      visit('/')
      click_on('GALLERY')
      expect(page).to have_content('There are no images here...')
    end
  end
end
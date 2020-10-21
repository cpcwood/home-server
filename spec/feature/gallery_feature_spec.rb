feature 'admin update gallery', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  context 'public user' do
    scenario 'no gallery images' do
      visit('/')
      click_on('GALLERY')
      expect(page).to have_current_path('/gallery')
      expect(page).to have_content('There are no images here...')
    end

    scenario 'gallery images' do
      seed_gallery_image
      visit('/gallery')
      expect(page).to have_selector('img.gallery-image-thumbnail')
      expect(page).to have_content(@gallery_image.description)
    end
  end
end
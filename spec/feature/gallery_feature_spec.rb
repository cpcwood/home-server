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
      expect(page.html).to include(@gallery_image.description)
    end
  end

  context 'admin user' do
    before(:each) do
      login_feature
    end

    scenario 'create new image' do
      visit('/gallery')
      click_on('Admin Edit')
      expect(page).to have_content('There are no images here...')
      click_on('Create New')
      fill_in('gallery_image[description]', with: 'new gallery image')
      fill_in('gallery_image[date_taken]', with: DateTime.new(2020, 04, 19, 0, 0, 0))
      fill_in('gallery_image[latitude]', with: 179)
      fill_in('gallery_image[longitude]', with: -179)
      find_field('gallery_image[image_file]').set(Rails.root.join('spec/files/sample_image.jpg'))
      click_button('Submit')
      expect(page).to have_content('Gallery image created')
      expect(page).to have_selector('img.gallery-image-thumbnail')
      expect(page.html).to include('new gallery image')
    end
  end
end
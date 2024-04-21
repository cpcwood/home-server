feature 'Admin update images', feature: true, slow: true do
  before(:each) do
    seed_user_and_settings
    login_feature
    visit('admin/images')
  end

  scenario 'Update custom image location' do
    fill_in('header_image_x_loc', match: :first, with: '10')
    first('.input-submit-tag').click
    expect(page).to have_content('Header image x loc updated!')
    visit('/')
    header_image = first('.header-image > img')
    expect(header_image[:style]).to match(/object-position: 10% 50%/)
  end

  scenario 'Update header image' do
    find_field('header_image[image_file]').set(Rails.root.join('spec/files/sample_image.jpg'))
    first('.input-submit-tag').click
    expect(page).to have_content('Header image updated!')
    visit('/')
    expect(page).to have_css("img[src*='image.jpg']")
    visit('admin/images')
    first("input[name='attachment[reset]']", text: '').set(true)
    first('.input-submit-tag').click
    expect(page).to have_content('Header image reset!')
    visit('/')
    expect(page).to_not have_css("img[src*='image.jpg']")
  end

  scenario 'Update custom image location' do
    fill_in('header_image_x_loc', match: :first, with: '10')
    first('.input-submit-tag').click
    expect(page).to have_content('Header image x loc updated!')
    visit('/')
    header_image = first('.header-image > img')
    expect(header_image[:style]).to match(/object-position: 10% 50%/)
  end
end

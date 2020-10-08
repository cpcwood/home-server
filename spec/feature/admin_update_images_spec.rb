require 'spec_helpers/feature_helpers'

feature 'Admin update images', feature: true, slow: true do
  scenario 'Update custom image location' do
    login_feature
    visit('admin/images')
    fill_in('header_image_x_loc', match: :first, with: '10')
    click_button('Update header image')
    expect(page).to have_content('Header image x loc updated!')
    visit('/')
    header_image = find('.header-image > img')
    expect(header_image[:style]).to match(/object-position: 10% 50%/)
  end
  
  scenario 'Update header image' do
    login_feature
    visit('admin/images')
    find_field('header_image[image_file]').set(Rails.root.join('spec/files/sample_image.jpg'))
    click_button('Update header image')
    expect(page).to have_content('Header image updated!')
    visit('/')
    expect(page).to have_css("img[src*='sample_image.jpg']")
    visit('admin/images')
    first("input[name='attachment[reset]']", text: '').set(true)
    click_button('Update header image')
    expect(page).to have_content('Header image reset!')
    visit('/')
    expect(page).to_not have_css("img[src*='sample_image.jpg']")
  end

  scenario 'Update custom image location' do
    login_feature
    visit('admin/images')
    fill_in('header_image_x_loc', match: :first, with: '10')
    click_button('Update header image')
    expect(page).to have_content('Header image x loc updated!')
    visit('/')
    header_image = find('.header-image > img')
    expect(header_image[:style]).to match(/object-position: 10% 50%/)
  end
end